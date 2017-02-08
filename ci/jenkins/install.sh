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
nginx_dest="/opt/nginx/conf.d/5-jenkins.conf"
nginx_checkpoint="/opt/jenkins/nginx.conf"
cert_dest="/opt/nginx/certs"

mkdir -p "$(dirname "$nginx_dest")"
mkdir -p "$(dirname "$nginx_checkpoint")"
mkdir -p "$cert_dest"

reload=0

if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "ci/jenkins nginx.conf changed"
  reload=1
fi

# TODO: checkpoints for the ssl files?
if [ ! -z "$(diff -Naur "$cert_dest/ci.ipfs.team.crt" "out/ci.ipfs.team.crt")" ]; then
  echo "ci/jenkins ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ci.ipfs.team.key" "out/ci.ipfs.team.key")" ]; then
  echo "ci/jenkins ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ci.ipfs.team.trustchain.crt" "out/ci.ipfs.team.trustchain.crt")" ]; then
  echo "ci/jenkins ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ci.ipfs.team.dhparam.pem" "out/ci.ipfs.team.dhparam.pem")" ]; then
  echo "ci/jenkins ssl dhparam changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "ci/jenkins nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  cp "out/ci.ipfs.team.crt" "$cert_dest/ci.ipfs.team.crt"
  cp "out/ci.ipfs.team.key" "$cert_dest/ci.ipfs.team.key"
  cp "out/ci.ipfs.team.trustchain.crt" "$cert_dest/ci.ipfs.team.trustchain.crt"
  cp "out/ci.ipfs.team.dhparam.pem" "$cert_dest/ci.ipfs.team.dhparam.pem"

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
