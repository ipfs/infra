#!/usr/bin/env bash

set -e

target="/opt/ipfs_v03x"
repo=$(lookup ipfs_v03x_repo)
api_port=$(lookup ipfs_v03x_api)

running=0
rebuild=0
restart=0

ref=$(lookup ipfs_v03x_ref | head -c 7)
actual_ref=$(docker ps --format '{{.Image}}' | grep "ipfs_v03x:" | cut -d':' -f2 || true)

if [ ! -z "$(docker ps -f status=running | grep "ipfs_v03x:" || true)" ]; then
  running=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "ref changed from $actual_ref to $ref"
  restart=1
fi

if [ -z "$(docker images -q ipfs_v03x:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/Dockerfile" "Dockerfile" || echo "new")" ]; then
  echo "ipfs_v03x dockerfile changed"
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/ipfs_v03x.opts" || echo "new")" ]; then
  echo "ipfs_v03x docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/config" "out/ipfs_v03x.config" || echo "new")" ]; then
  echo "ipfs_v03x config changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "ipfs_v03x rebuilding"
  [ -d "$target/src/.git" ] || git clone -q $(lookup ipfs_v03x_git) "$target/src"
  git --git-dir="$target/src/.git" remote set-url origin $(lookup ipfs_v03x_git)
  git --git-dir="$target/src/.git" fetch -q --all
  git --git-dir="$target/src/.git" --work-tree="$target/src" reset -q --hard "$ref"
  cp Dockerfile "$target/src"
  rm "$target/src/.dockerignore"
  docker build -t "ipfs_v03x:$ref" "$target/src" >/dev/null
  echo "ipfs_v03x docker image changed"
  restart=1
fi

if [ ! -f "$repo/config" ]; then
  mkdir -p "$repo"
  docker run -i -v "$repo:/data/ipfs" --entrypoint /bin/sh "ipfs_v03x:$ref" sh -c 'ipfs init --bits 2048'
  chown -R 1000:users "$repo"
  restart=1
fi

cp "out/ipfs_v03x.config" "$repo/config"

if [ "restart$restart" == "restart1" ]; then
  echo "ipfs_v03x restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "ipfs_v03x" >/dev/null || true
    docker rm -f "ipfs_v03x" >/dev/null || true
  fi
  docker run $(cat out/ipfs_v03x.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "ipfs_v03x starting"
  docker run $(cat out/ipfs_v03x.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "out/ipfs_v03x.config" "$target/config"
cp -a "out/ipfs_v03x.opts" "$target/docker.opts"
cp -a "Dockerfile" "$target/Dockerfile"
