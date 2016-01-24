#!/usr/bin/env bash

set -e

target="/opt/multireq"

running=0
rebuild=0
restart=0

ref=$(lookup multireq_ref)
actual_ref=$(docker ps --format '{{.Image}}' | grep "multireq:" | cut -d':' -f2 || true)

if [ ! -z "$actual_ref" ]; then
  running=1
fi

if [ "$ref" != "$actual_ref" ]; then
  restart=1
fi

if [ -z "$(docker images -q multireq:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/Dockerfile" "Dockerfile" || echo "new")" ]; then
  echo "$host: multireq dockerfile changed"
  rebuild=1
  restart=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "docker.opts" || echo "new")" ]; then
  echo "$host: multireq docker.opts changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "$host: multireq rebuilding"
  mkdir -p src/
  git clone -q $(lookup multireq_git) "src/multireq"
  git --work-tree="src/multireq" --git-dir="src/multireq/.git" reset -q --hard "$ref"
  cp Dockerfile "src/multireq"
  docker build -t "multireq:$ref" "src/multireq" >/dev/null
  echo "$host: multireq docker image changed"
fi

if [ "restart$restart" == "restart1" ]; then
  echo "$host: multireq restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "multireq" >/dev/null || true
    docker rm -f "multireq" >/dev/null || true
  fi
  docker run $(cat docker.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "$host: multireq starting"
  docker run $(cat docker.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "docker.opts" "$target/docker.opts"
cp -a "Dockerfile" "$target/Dockerfile"
