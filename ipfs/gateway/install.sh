#!/usr/bin/env bash

set -e

target="/opt/nginx"

reload=0

if [ ! -z "$(diff -Naur "$target/conf.d/6-ipfs-gateway.conf" "out/6-ipfs-gateway.conf")" ]; then
  echo "ipfs/gateway nginx config changed"
  reload=1
fi

cp "out/6-ipfs-gateway.conf" "$target/conf.d/6-ipfs-gateway.conf"

if [ "reload$reload" == "reload1" ]; then
  echo "ipfs/gateway nginx reloading"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
  echo $out | grep -v failed >/dev/null && echo $out && exit 1
fi
