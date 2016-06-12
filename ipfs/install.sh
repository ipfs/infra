#!/usr/bin/env bash

set -e

target="/opt/ipfs"
repo=$(lookup ipfs_repo)
api_port=$(lookup ipfs_api)

running=0
rebuild=0
restart=0

ref=$(lookup ipfs_ref | head -c 7)
actual_ref=$(docker ps --format '{{.Image}}' | grep "ipfs:" | cut -d':' -f2 || true)

if [ ! -z "$(docker ps -f status=running | grep "ipfs:" || true)" ]; then
  running=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "ref changed from $actual_ref to $ref"
  restart=1
fi

if [ -z "$(docker images -q ipfs:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/ipfs.opts" || echo "new")" ]; then
  echo "ipfs docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/config" "out/ipfs.config" || echo "new")" ]; then
  echo "ipfs config changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "ipfs rebuilding"
  [ -d "$target/src/.git" ] || git clone -q $(lookup ipfs_git) "$target/src"
  git --git-dir="$target/src/.git" remote set-url origin $(lookup ipfs_git)
  git --git-dir="$target/src/.git" remote prune origin >/dev/null
  git --git-dir="$target/src/.git" gc
  git --git-dir="$target/src/.git" fetch -q --all
  git --git-dir="$target/src/.git" --work-tree="$target/src" reset -q --hard "$ref"
  docker build -t "ipfs:$ref" "$target/src" >/dev/null
  echo "ipfs docker image changed"
  restart=1
fi

if [ ! -f "$repo/config" ]; then
  mkdir -p "$repo"
  docker run -i -v "$repo:/data/ipfs" --entrypoint /bin/sh "ipfs:$ref" sh -c 'ipfs init --bits 2048'
  chown -R 1000:users "$repo"
  restart=1
fi

cp "out/ipfs.config" "$repo/config"

if [ "restart$restart" == "restart1" ]; then
  echo "ipfs restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "ipfs" >/dev/null || true
    docker rm -f "ipfs" >/dev/null || true
  fi
  docker run $(cat out/ipfs.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "ipfs starting"
  docker run $(cat out/ipfs.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "out/ipfs.config" "$target/config"
cp -a "out/ipfs.opts" "$target/docker.opts"
rm -f "$target/Dockerfile"
