#!/usr/bin/env bash

set -e

target="/opt/nginx"

reload=0

if [ ! -z "$(diff -Naur "$target/conf.d/0-ssl.conf" "out/0-ssl.conf")" ]; then
  echo "ssl nginx config changed"
  reload=1
fi

cp "out/0-ssl.conf" "$target/conf.d/0-ssl.conf"

if [ "reload$reload" == "reload1" ]; then
  echo "ssl nginx reloading"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
  echo $out | grep -v failed >/dev/null && echo $out && exit 1
fi
