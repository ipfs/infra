#!/usr/bin/env bash

set -e

target="/opt/nginx"

reload=0

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.crt" "out/ipfs.io.crt")" ]; then
  echo "ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.key" "out/ipfs.io.key")" ]; then
  echo "ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.trustchain.crt" "out/ipfs.io.trustchain.crt")" ]; then
  echo "ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/dhparam.pem" "out/dhparam.pem")" ]; then
  echo "ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/conf.d/0-ssl.conf" "out/0-ssl.conf")" ]; then
  echo "ssl nginx config changed"
  reload=1
fi

cp "out/ipfs.io.crt" "$target/certs/ipfs.io.crt"
cp "out/ipfs.io.key" "$target/certs/ipfs.io.key"
cp "out/ipfs.io.trustchain.crt" "$target/certs/ipfs.io.trustchain.crt"
cp "out/dhparam.pem" "$target/certs/dhparam.pem"
cp "out/0-ssl.conf" "$target/conf.d/0-ssl.conf"

if [ "reload$reload" == "reload1" ]; then
  echo "ssl nginx reloading"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
  echo $out | grep -v failed >/dev/null && echo $out && exit 1
fi
