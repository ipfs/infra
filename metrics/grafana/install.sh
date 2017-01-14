#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks for grafana.ini or docker.opts changes
# 2. Restarts grafana container if these or the requested version changed
# 3. Starts grafana container if it wasn't already running
# 4. Checks if nginx.conf changed
# 5. Applies change and reloads nginx
# 6. Rolls back nginx.conf if reload fails
#
# About rolling back nginx.conf:
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

target="/opt/grafana"

restart=0

ref=$(lookup grafana_ref)
actual_ref=$(docker ps --format '{{.Image}}' | grep "grafana:" | cut -d':' -f2 || true)

if [ -z "$(docker ps -f status=running | grep "grafana:" || true)" ]; then
  echo "metrics/grafana not running"
  restart=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "metrics/grafana changed from $actual_ref to $ref"
  restart=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/docker.opts" || echo "new")" ]; then
  echo "metrics/grafana docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/config/grafana.ini" "out/grafana.ini" || echo "new")" ]; then
  echo "metrics/grafana config changed"
  restart=1
fi

mkdir -p "$target/config"
mkdir -p "$target/data"
cp "out/grafana.ini" "$target/config/grafana.ini"

if [ "restart$restart" == "restart1" ]; then
  echo "metrics/grafana (re)starting"
  docker stop "grafana" 2>&1 >/dev/null || true
  docker rm -f "grafana" 2>&1 >/dev/null || true
  docker run $(cat out/docker.opts) >/dev/null
fi

# We only install docker.opts so we can get a diff later and restart if needed.
cp "out/docker.opts" "$target/docker.opts"

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/7-grafana.conf"
nginx_checkpoint="$target/nginx.conf"

mkdir -p "$(dirname "$nginx_dest")"
mkdir -p "$(dirname "$nginx_checkpoint")"

reload=0
if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "metrics/grafana nginx.conf changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "metrics/grafana nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')

  if echo $out | grep failed >/dev/null; then
    echo $out
    # Reload failed, roll back.
    cp "$nginx_checkpoint" "$nginx_dest" || true
    exit 1
  fi

  # Sucessfully reloaded, now "commit" the checkpoint file.
  cp "$nginx_src" "$nginx_checkpoint"
fi
