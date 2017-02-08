#!/usr/bin/env bash

set -e

target="/opt/nginx"

reload=0

if [ ! -z "$(diff -Naur "$target/conf.d/6-ipfs-gateway.conf" "out/6-ipfs-gateway.conf")" ]; then
  echo "ipfs/gateway nginx config changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.crt" "out/ipfs.io.crt")" ]; then
  echo "ipfs/gateway ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.key" "out/ipfs.io.key")" ]; then
  echo "ipfs/gateway ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/ipfs.io.trustchain.crt" "out/ipfs.io.trustchain.crt")" ]; then
  echo "ipfs/gateway ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$target/certs/dhparam.pem" "out/dhparam.pem")" ]; then
  echo "ipfs/gateway ssl dhparam changed"
  reload=1
fi

cp "out/6-ipfs-gateway.conf" "$target/conf.d/6-ipfs-gateway.conf"
cp "out/ipfs.io.crt" "$target/certs/ipfs.io.crt"
cp "out/ipfs.io.key" "$target/certs/ipfs.io.key"
cp "out/ipfs.io.trustchain.crt" "$target/certs/ipfs.io.trustchain.crt"
# TODO: rename to ipfs.io.dhparam.pem
cp "out/dhparam.pem" "$target/certs/dhparam.pem"

if [ "reload$reload" == "reload1" ]; then
  echo "ipfs/gateway nginx reloading"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')
  echo $out | grep -v failed >/dev/null && echo $out && exit 1
fi
