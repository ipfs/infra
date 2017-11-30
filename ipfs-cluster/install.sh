#!/usr/bin/env bash

set -e

target="/opt/ipfs-cluster"
data=$(lookup ipfs_cluster_data)

rebuild=0
restart=0

ref=$(lookup ipfs_cluster_ref | head -c 7)
actual_ref=$(docker ps --format '{{.Image}}' | grep "ipfs-cluster:" | cut -d':' -f2 || true)

if [ -z "$(docker ps -f status=running | grep "ipfs-cluster:" || true)" ]; then
  echo "daemon not running"
  restart=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "ref changed from $actual_ref to $ref"
  restart=1
fi

if [ -z "$(docker images -q ipfs-cluster:${ref})" ]; then
  echo "docker image doesn't exist yet"
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/ipfs-cluster.opts" || echo "new")" ]; then
  echo "ipfs-cluster docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/service.json" "out/ipfs-cluster_service.json" || echo "new")" ]; then
  echo "ipfs-cluster config changed"
  restart=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "ipfs-cluster rebuilding"
  [ -d "$target/src/.git" ] || git clone -q "$(lookup ipfs_cluster_git)" "$target/src"
  git --git-dir="$target/src/.git" remote set-url origin $(lookup ipfs_cluster_git)
  git --git-dir="$target/src/.git" remote prune origin >/dev/null
  git --git-dir="$target/src/.git" prune
  git --git-dir="$target/src/.git" gc --quiet
  git --git-dir="$target/src/.git" fetch -q --all
  git --git-dir="$target/src/.git" --work-tree="$target/src" reset -q --hard "$ref"
  docker build -t "ipfs-cluster:$ref" "$target/src" >/dev/null
  echo "ipfs-cluster docker image changed"
  restart=1
fi

if [ ! -f "$data/service.json" ]; then
  mkdir -p "$data"
  chown -R 1000:users "$data"
  restart=1
fi

cp "out/ipfs-cluster_service.json" "$data/service.json"
chown 1000:users "$data/service.json"

if [ "restart$restart" == "restart1" ]; then
  echo "ipfs-cluster (re)starting"
  docker stop "ipfs-cluster" >/dev/null 2>&1 || true
  docker rm -f "ipfs-cluster" >/dev/null 2>&1 || true
  docker run $(cat out/ipfs-cluster.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "out/ipfs-cluster_service.json" "$target/service.json"
cp -a "out/ipfs-cluster.opts" "$target/docker.opts"
rm -f "$target/Dockerfile"

if [ -d /opt/nginx ]; then
  reload=0
  if [ ! -z "$(diff -Naur "/opt/nginx/conf.d/7-ipfs-cluster.conf" "out/7-ipfs-cluster.conf")" ]; then
    echo "ipfs nginx config changed"
    cp "out/7-ipfs-cluster.conf" "/opt/nginx/conf.d/7-ipfs-cluster.conf"
    reload=1
  fi

  if [ "reload$reload" == "reload1" ]; then
    echo "ipfs nginx reloading"
    out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
    echo $out | grep -v failed >/dev/null && echo $out && exit 1
  fi
fi
