#!/usr/bin/env bash

set -e

target="/opt/ipfs"
repo=$(lookup ipfs_repo)
api_port=$(lookup ipfs_api)
profile=$(lookup ipfs_profile)

rebuild=0
restart=0

ref=$(lookup ipfs_ref | head -c 7)
actual_ref=$(docker ps --format '{{.Image}}' | grep "ipfs:" | cut -d':' -f2 || true)

if [ -z "$(docker ps -f status=running | grep "ipfs:" || true)" ]; then
  echo "daemon not running"
  restart=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "ref changed from $actual_ref to $ref"
  restart=1
fi

if [ -z "$(docker images -q ipfs:$ref)" ]; then
  echo "docker image doesn't exist yet"
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
  git --git-dir="$target/src/.git" prune
  git --git-dir="$target/src/.git" gc --quiet
  git --git-dir="$target/src/.git" fetch -q --all
  git --git-dir="$target/src/.git" --work-tree="$target/src" reset -q --hard "$ref"
  docker build -t "ipfs:$ref" "$target/src" >/dev/null
  echo "ipfs docker image changed"
  restart=1
fi

if [ ! -f "$repo/config" ]; then
  mkdir -p "$repo"
  chown -R 1000:users "$repo"
  docker run -i -u 1000 -v "$repo:/data/ipfs" --entrypoint /bin/sh "ipfs:$ref" -c "ipfs init --bits 2048 --profile=$profile"
  restart=1
fi

dsconf=$(cat "$repo/config" | jq -c .Datastore.Spec)
cat "out/ipfs.config" | jq ".Datastore.Spec = $dsconf" > "$repo/config"

if [ "restart$restart" == "restart1" ]; then
  echo "ipfs (re)starting"
  docker stop "ipfs" 2>&1 >/dev/null || true
  docker rm -f "ipfs" 2>&1 >/dev/null || true
  docker run $(cat out/ipfs.opts) >/dev/null
fi

# we only install these so we can get a diff and rebuild/restart if needed
mkdir -p "$target"
cp -a "out/ipfs.config" "$target/config"
cp -a "out/ipfs.opts" "$target/docker.opts"
rm -f "$target/Dockerfile"

if [ -d /opt/nginx ]; then
  reload=0
  if [ ! -z "$(diff -Naur "/opt/nginx/conf.d/6-ipfs.conf" "out/6-ipfs.conf")" ]; then
    echo "ipfs nginx config changed"
    cp "out/6-ipfs.conf" "/opt/nginx/conf.d/6-ipfs.conf"
    reload=1
  fi

  if [ "reload$reload" == "reload1" ]; then
    echo "ipfs nginx reloading"
    out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
    echo $out | grep -v failed >/dev/null && echo $out && exit 1
  fi
fi
