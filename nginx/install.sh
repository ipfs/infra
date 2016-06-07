#!/usr/bin/env bash

set -e

target="/opt/nginx"

running=0
rebuild=0
reload=0
restart=0

image=$(lookup nginx_image)
ref=$(lookup nginx_ref | head -c 7)
actual_ref=$(docker ps --format '{{.Image}}' | grep "$image:" | cut -d':' -f2 || true)

if [ ! -z "$(docker ps -f status=running | grep "nginx:" || true)" ]; then
  running=1
fi

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "nginx ref changed from [$actual_ref] to [$ref]"
  restart=1
fi

if [ -z "$(docker images -q $image:$ref)" ]; then
  rebuild=1
fi

if [ ! -z "$(git diff "$target/docker.opts" "out/docker.opts" || echo "new")" ]; then
  echo "nginx docker.opts changed"
  restart=1
fi

if [ ! -z "$(git diff "$target/conf.d/0-nginx.conf" "out/nginx.conf" || echo "new")" ]; then
  echo "nginx config changed"
  reload=1
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "nginx pulling image"
  docker pull "$image:$ref" >/dev/null
  echo "nginx docker image changed"
  restart=1
fi

mkdir -p "$target/conf.d"
mkdir -p "$target/certs"
mkdir -p "$target/logs"
mkdir -p "$target/html/_errors"

cp "out/nginx.conf" "$target/conf.d/0-nginx.conf"
cp "out/451.html" "$target/html/_errors/451.html"

if [ "restart$restart" == "restart1" ]; then
  echo "nginx restarting"
  if [ "running$running" == "running1" ]; then
    docker stop "nginx" >/dev/null || true
    docker rm -f "nginx" >/dev/null || true
  fi
  docker run $(cat out/docker.opts) >/dev/null
elif [ "running$running" == "running0" ]; then
  echo "nginx starting"
  docker run $(cat out/docker.opts) >/dev/null
elif [ "reload$reload" == "reload1" ]; then
  echo "nginx reloading"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
  echo $out | grep -v failed >/dev/null && echo $out && exit 1
fi

# we only install this only so we can get a diff and rebuild/restart if needed
cp -a "out/docker.opts" "$target/docker.opts"
