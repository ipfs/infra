#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks for prometheus.yml or docker.opts changes
# 2. Rebuilds prometheus docker image if requested version changed
# 3. Restarts prometheus container if any of the above
# 4. Starts prometheus container if it wasn't already running
#
# TODO: config reloading via SIGHUP

target="/opt/prometheus"

running=0
rebuild=0
restart=0

ref=$(lookup prometheus_ref)
actual_ref=$(docker ps --format '{{.Image}}' | grep "prometheus:" | cut -d':' -f2 || true)

if [ ! -z "$actual_ref" ]; then
  running=1
fi

if [ "$ref" != "$actual_ref" ]; then
  rebuild=1
fi

if [ -z "$(docker images -q prometheus:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/docker.opts" 2>&1 || echo "new")" ]; then
  echo "prometheus docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/config/prometheus.yml" "out/prometheus.yml" 2>&1 || echo "new")" ]; then
  echo "prometheus prometheus.yml changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "prometheus rebuilding"
  go get -d github.com/prometheus/prometheus/cmd/...
  cd $GOPATH/src/github.com/prometheus/prometheus/
  git remote set-url origin https://github.com/prometheus/prometheus
  git remote prune origin >/dev/null
  git gc
  git fetch -q --all
  git reset -q --hard "$ref"
  git clean -qfdx
  docker pull quay.io/prometheus/busybox:latest
  docker pull quay.io/prometheus/busybox:glibc
  DOCKER_IMAGE_TAG="$ref" make build docker >/dev/null
  cd -
  echo "prometheus docker image changed"
  restart=1
fi

mkdir -p "$target/config"
cp "out/prometheus.yml" "$target/config/"

if [ "restart$restart" == "restart1" ]; then
  echo "prometheus restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "prometheus" >/dev/null || true
  fi
  docker rm -f "prometheus" >/dev/null || true
  docker run $(cat out/docker.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "prometheus starting"
  docker run $(cat out/docker.opts) >/dev/null
fi

# We only install docker.opts so we can get a diff later and restart if needed
cp "out/docker.opts" "$target/docker.opts"
