#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks if nginx.conf changed
# 2. Applies change and reloads nginx
# 3. Rolls back nginx.conf if reload fails
#
# About rolling back nginx.conf:
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/6-pages.conf"
nginx_checkpoint="/opt/pages/nginx.conf"
cert_dest="/opt/nginx/certs"

mkdir -p "$(dirname "$nginx_dest")"
mkdir -p "$(dirname "$nginx_checkpoint")"
mkdir -p "$cert_dest"

reload=0

if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "ipfs/pages nginx.conf changed"
  reload=1
fi

# TODO: checkpoints for the ssl files?
if [ ! -z "$(diff -Naur "$cert_dest/orbit.chat.crt" "out/orbit.chat.crt")" ]; then
  echo "ipfs/pages orbit.chat ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/orbit.chat.key" "out/orbit.chat.key")" ]; then
  echo "ipfs/pages orbit.chat ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/orbit.chat.trustchain.crt" "out/orbit.chat.trustchain.crt")" ]; then
  echo "ipfs/pages orbit.chat ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/orbit.chat.dhparam.pem" "out/orbit.chat.dhparam.pem")" ]; then
  echo "ipfs/pages orbit.chat ssl dhparam changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "ipfs/pages nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  cp "out/orbit.chat.crt" "$cert_dest/orbit.chat.crt"
  cp "out/orbit.chat.key" "$cert_dest/orbit.chat.key"
  cp "out/orbit.chat.trustchain.crt" "$cert_dest/orbit.chat.trustchain.crt"
  cp "out/orbit.chat.dhparam.pem" "$cert_dest/orbit.chat.dhparam.pem"

  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')

  if echo $out | grep failed >/dev/null; then
    echo $out
    # Reload failed, roll back.
    cp "$nginx_checkpoint" "$nginx_dest" || true
    exit 1
  fi

  # Sucessfully reloaded, now "commit" the checkpoint file.
  cp "$nginx_src" "$nginx_checkpoint"
fi
