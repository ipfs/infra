#!/usr/bin/env bash

set -e

target="/opt/mtail"

running=0
rebuild=0
restart=0

ref=$(lookup mtail_ref)
actual_ref=$(docker ps --format '{{.Image}}' | grep "mtail:" | cut -d':' -f2 || true)

if [ ! -z "$actual_ref" ]; then
  running=1
fi

if [ "$ref" != "$actual_ref" ]; then
  restart=1
fi

if [ -z "$(docker images -q mtail:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/Dockerfile" "Dockerfile" || echo "new")" ]; then
  echo "$host: mtail dockerfile changed"
  rebuild=1
  restart=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "docker.opts" || echo "new")" ]; then
  echo "$host: mtail docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/progs/nginx.mtail" "progs/nginx.mtail" || echo "new")" ]; then
  echo "$host: mtail nginx.mtail changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "$host: mtail rebuilding"
  mkdir -p src/
  git clone -q $(lookup mtail_git) "src/mtail"
  git --work-tree="src/mtail" --git-dir="src/mtail/.git" reset -q --hard "$ref"
  cp Dockerfile "src/mtail"
  docker build -t "mtail:$ref" "src/mtail" #>/dev/null
  echo "$host: mtail docker image changed"
fi

mkdir -p "$target/logs" "$target/progs"
cp "progs/nginx.mtail" "$target/progs/nginx.mtail"

if [ "restart$restart" == "restart1" ]; then
  echo "$host: mtail restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "mtail" >/dev/null || true
    docker rm -f "mtail" >/dev/null || true
  fi
  docker run $(cat docker.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "$host: mtail starting"
  docker run $(cat docker.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
cp -a "docker.opts" "$target/docker.opts"
cp -a "Dockerfile" "$target/Dockerfile"
