#!/usr/bin/env bash

set -e

target="/opt/blackbox_exporter"
mkdir -p "$target"

rebuild=0
restart=0

ref=$(lookup blackbox_exporter_ref)
actual_ref=$(docker ps --format '{{.Image}}' | grep "blackbox_exporter:" | cut -d':' -f2 || true)

if [ -z "$(docker ps -f status=running | grep "blackbox_exporter:" || true)" ]; then
  echo "daemon not running"
  restart=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "ref changed from $actual_ref to $ref"
  restart=1
fi

if [ -z "$(docker images -q blackbox_exporter:$ref)" ]; then
  echo "docker image doesn't exist yet"
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/docker.opts" || echo "new")" ]; then
  echo "blackbox_exporter docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/config.yml" "out/config.yml" || echo "new")" ]; then
  echo "blackbox_exporter config changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "blackbox_exporter rebuilding"
  go get -d github.com/prometheus/blackbox_exporter
  cd $GOPATH/src/github.com/prometheus/blackbox_exporter/
  git remote set-url origin https://github.com/prometheus/blackbox_exporter
  git remote prune origin >/dev/null
  git gc
  git fetch -q --all
  git reset -q --hard "$ref"
  DOCKER_IMAGE_NAME=blackbox_exporter DOCKER_IMAGE_TAG="$ref" make build docker >/dev/null
  cd -
  echo "blackbox_exporter docker image changed"
  restart=1
fi

cp "out/config.yml" "$target/config.yml"

if [ "restart$restart" == "restart1" ]; then
  echo "blackbox_exporter (re)starting"
  docker stop "blackbox_exporter" |& cat >/dev/null || true
  docker rm -f "blackbox_exporter" |& cat >/dev/null || true
  docker run $(cat out/docker.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "out/config.yml" "$target/config.yml"
cp -a "out/docker.opts" "$target/docker.opts"

# How this install script works
#
# Checks if the config changed, applies the change, reloads nginx if neccessary.
# Rolls back the change if reloading fails.
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/7-blackbox-exporter.conf"
nginx_checkpoint="/opt/blackbox_exporter/nginx.conf"

mkdir -vp "$(dirname "$nginx_dest")"
mkdir -vp "$(dirname "$nginx_checkpoint")"

reload=0
if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "metrics/blackbox_exporter nginx config changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "metrics/blackbox_exporter nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')

  if echo $out | grep failed >/dev/null; then
    echo $out
    # reload failed, roll back
    cp "$nginx_checkpoint" "$nginx_dest" || true
    exit 1
  fi

  # sucessfully reloaded, now "commit" the checkpoint file
  cp -v "$nginx_src" "$nginx_checkpoint"
fi
