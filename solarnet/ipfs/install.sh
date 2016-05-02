#!/usr/bin/env bash

set -e

ipfs_install() {
  name="$1"
  target="/opt/$name"
  repo=$(lookup $name'_repo')
  api_port=$(lookup $name'_api')

  running=0
  rebuild=0
  restart=0

  ref=$(lookup $name'_ref' | head -c 7)
  actual_ref=$(docker ps --format '{{.Image}}' | grep "$name:" | cut -d':' -f2 || true)

  if [ ! -z "$(docker ps -f status=running | grep "$name:" || true)" ]; then
    running=1
  fi

  if [ "ref$ref" != "ref$actual_ref" ]; then
    echo "$host: ref changed from $ref to $actual_ref"
    restart=1
  fi

  if [ -z "$(docker images -q $name:$ref)" ]; then
    rebuild=1
  fi

  if [ "name$name" == "nameipfs_v03x" ]; then
    if [ ! -z "$(git diff "$target/Dockerfile" "Dockerfile" || echo "new")" ]; then
      echo "$host: $name dockerfile changed"
      rebuild=1
    fi
  fi

  if [ ! -z "$(git diff "$target/docker.opts" "out/$name.opts" || echo "new")" ]; then
    echo "$host: $name docker.opts changed"
    restart=1
  fi

  if [ ! -z "$(git diff "$target/config" "out/$name.config" || echo "new")" ]; then
    echo "$host: $name config changed"
    restart=1
  fi

  if [ "rebuild$rebuild" == "rebuild1" ]; then
    echo "$host: $name rebuilding"
    [ -d "$target/src/.git" ] || git clone -q $(lookup $name'_git') "$target/src"
    git --git-dir="$target/src/.git" remote set-url origin $(lookup $name'_git')
    git --git-dir="$target/src/.git" fetch -q --all
    git --git-dir="$target/src/.git" --work-tree="$target/src" reset -q --hard "$ref"
    if [ "name$name" == "nameipfs_v03x" ]; then
      cp Dockerfile "$target/src"
      rm "$target/src/.dockerignore"
    fi
    docker build -t "$name:$ref" "$target/src" >/dev/null
    echo "$host: $name docker image changed"
    restart=1
  fi

  if [ ! -f "$repo/config" ]; then
    mkdir -p "$repo"
    docker run -i -v "$repo:/data/ipfs" --entrypoint /bin/sh "$name:$ref" sh -c 'ipfs init --bits 2048'
    chown -R 1000:users "$repo"
    restart=1
  fi

  cp "out/$name.config" "$repo/config"

  if [ "restart$restart" == "restart1" ]; then
    echo "$host: $name restarting"
    if [ "running$running" == "running1" ]; then
      docker stop "$name" >/dev/null || true
      docker rm -f "$name" >/dev/null || true
    fi
    docker run $(cat out/$name.opts) >/dev/null
  elif [ "running$running" == "running0" ]; then
    echo "$host: $name starting"
    docker run $(cat out/$name.opts) >/dev/null
  fi

  # we only install these so we can get a diff and rebuild/restart if needed
  mkdir -p "$target"
  cp -a "out/$name.config" "$target/config"
  cp -a "out/$name.opts" "$target/docker.opts"
  if [ "name$name" == "nameipfs_v03x" ]; then
    cp -a "Dockerfile" "$target/Dockerfile"
  else
    rm -f "$target/Dockerfile"
  fi
}

ipfs_install ipfs
ipfs_install ipfs_v03x
