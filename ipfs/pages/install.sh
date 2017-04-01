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

if [ ! -z "$(diff -Naur "$cert_dest/bootstrap.libp2p.io.crt" "out/bootstrap.libp2p.io.crt")" ]; then
  echo "ipfs/pages *.bootstrap.libp2p.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/bootstrap.libp2p.io.key" "out/bootstrap.libp2p.io.key")" ]; then
  echo "ipfs/pages *.bootstrap.libp2p.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/bootstrap.libp2p.io.trustchain.crt" "out/bootstrap.libp2p.io.trustchain.crt")" ]; then
  echo "ipfs/pages *.bootstrap.libp2p.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/bootstrap.libp2p.io.dhparam.pem" "out/bootstrap.libp2p.io.dhparam.pem")" ]; then
  echo "ipfs/pages *.bootstrap.libp2p.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ipld.io.crt" "out/ipld.io.crt")" ]; then
  echo "ipfs/pages ipld.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ipld.io.key" "out/ipld.io.key")" ]; then
  echo "ipfs/pages ipld.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ipld.io.trustchain.crt" "out/ipld.io.trustchain.crt")" ]; then
  echo "ipfs/pages ipld.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ipld.io.dhparam.pem" "out/ipld.io.dhparam.pem")" ]; then
  echo "ipfs/pages ipld.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/libp2p.io.crt" "out/libp2p.io.crt")" ]; then
  echo "ipfs/pages libp2p.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/libp2p.io.key" "out/libp2p.io.key")" ]; then
  echo "ipfs/pages libp2p.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/libp2p.io.trustchain.crt" "out/libp2p.io.trustchain.crt")" ]; then
  echo "ipfs/pages libp2p.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/libp2p.io.dhparam.pem" "out/libp2p.io.dhparam.pem")" ]; then
  echo "ipfs/pages libp2p.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/multiformats.io.crt" "out/multiformats.io.crt")" ]; then
  echo "ipfs/pages multiformats.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/multiformats.io.key" "out/multiformats.io.key")" ]; then
  echo "ipfs/pages multiformats.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/multiformats.io.trustchain.crt" "out/multiformats.io.trustchain.crt")" ]; then
  echo "ipfs/pages multiformats.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/multiformats.io.dhparam.pem" "out/multiformats.io.dhparam.pem")" ]; then
  echo "ipfs/pages multiformats.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/zcash.dag.ipfs.io.crt" "out/zcash.dag.ipfs.io.crt")" ]; then
  echo "ipfs/pages zcash.dag.ipfs.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/zcash.dag.ipfs.io.key" "out/zcash.dag.ipfs.io.key")" ]; then
  echo "ipfs/pages zcash.dag.ipfs.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/zcash.dag.ipfs.io.trustchain.crt" "out/zcash.dag.ipfs.io.trustchain.crt")" ]; then
  echo "ipfs/pages zcash.dag.ipfs.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/zcash.dag.ipfs.io.dhparam.pem" "out/zcash.dag.ipfs.io.dhparam.pem")" ]; then
  echo "ipfs/pages zcash.dag.ipfs.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/protocol.ai.crt" "out/protocol.ai.crt")" ]; then
  echo "ipfs/pages protocol.ai ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/protocol.ai.key" "out/protocol.ai.key")" ]; then
  echo "ipfs/pages protocol.ai ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/protocol.ai.trustchain.crt" "out/protocol.ai.trustchain.crt")" ]; then
  echo "ipfs/pages protocol.ai ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/protocol.ai.dhparam.pem" "out/protocol.ai.dhparam.pem")" ]; then
  echo "ipfs/pages protocol.ai ssl dhparam changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "ipfs/pages nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  cp "out/orbit.chat.crt" "$cert_dest/orbit.chat.crt"
  cp "out/orbit.chat.key" "$cert_dest/orbit.chat.key"
  cp "out/orbit.chat.trustchain.crt" "$cert_dest/orbit.chat.trustchain.crt"
  cp "out/orbit.chat.dhparam.pem" "$cert_dest/orbit.chat.dhparam.pem"
  cp "out/bootstrap.libp2p.io.crt" "$cert_dest/bootstrap.libp2p.io.crt"
  cp "out/bootstrap.libp2p.io.key" "$cert_dest/bootstrap.libp2p.io.key"
  cp "out/bootstrap.libp2p.io.trustchain.crt" "$cert_dest/bootstrap.libp2p.io.trustchain.crt"
  cp "out/bootstrap.libp2p.io.dhparam.pem" "$cert_dest/bootstrap.libp2p.io.dhparam.pem"
  cp "out/ipld.io.crt" "$cert_dest/ipld.io.crt"
  cp "out/ipld.io.key" "$cert_dest/ipld.io.key"
  cp "out/ipld.io.trustchain.crt" "$cert_dest/ipld.io.trustchain.crt"
  cp "out/ipld.io.dhparam.pem" "$cert_dest/ipld.io.dhparam.pem"
  cp "out/libp2p.io.crt" "$cert_dest/libp2p.io.crt"
  cp "out/libp2p.io.key" "$cert_dest/libp2p.io.key"
  cp "out/libp2p.io.trustchain.crt" "$cert_dest/libp2p.io.trustchain.crt"
  cp "out/libp2p.io.dhparam.pem" "$cert_dest/libp2p.io.dhparam.pem"
  cp "out/multiformats.io.crt" "$cert_dest/multiformats.io.crt"
  cp "out/multiformats.io.key" "$cert_dest/multiformats.io.key"
  cp "out/multiformats.io.trustchain.crt" "$cert_dest/multiformats.io.trustchain.crt"
  cp "out/multiformats.io.dhparam.pem" "$cert_dest/multiformats.io.dhparam.pem"
  cp "out/zcash.dag.ipfs.io.crt" "$cert_dest/zcash.dag.ipfs.io.crt"
  cp "out/zcash.dag.ipfs.io.key" "$cert_dest/zcash.dag.ipfs.io.key"
  cp "out/zcash.dag.ipfs.io.trustchain.crt" "$cert_dest/zcash.dag.ipfs.io.trustchain.crt"
  cp "out/zcash.dag.ipfs.io.dhparam.pem" "$cert_dest/zcash.dag.ipfs.io.dhparam.pem"
  cp "out/protocol.ai.crt" "$cert_dest/protocol.ai.crt"
  cp "out/protocol.ai.key" "$cert_dest/protocol.ai.key"
  cp "out/protocol.ai.trustchain.crt" "$cert_dest/protocol.ai.trustchain.crt"
  cp "out/protocol.ai.dhparam.pem" "$cert_dest/protocol.ai.dhparam.pem"

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
