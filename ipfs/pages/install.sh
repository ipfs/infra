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
if [ ! -z "$(diff -Naur "$cert_dest/i.ipfs.io.crt" "out/i.ipfs.io.crt")" ]; then
  echo "ipfs/pages i.ipfs.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/i.ipfs.io.key" "out/i.ipfs.io.key")" ]; then
  echo "ipfs/pages i.ipfs.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/i.ipfs.io.trustchain.crt" "out/i.ipfs.io.trustchain.crt")" ]; then
  echo "ipfs/pages i.ipfs.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/i.ipfs.io.dhparam.pem" "out/i.ipfs.io.dhparam.pem")" ]; then
  echo "ipfs/pages i.ipfs.io ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/filecoin.io.crt" "out/filecoin.io.crt")" ]; then
  echo "ipfs/pages filecoin.io ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/filecoin.io.key" "out/filecoin.io.key")" ]; then
  echo "ipfs/pages filecoin.io ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/filecoin.io.trustchain.crt" "out/filecoin.io.trustchain.crt")" ]; then
  echo "ipfs/pages filecoin.io ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/filecoin.io.dhparam.pem" "out/filecoin.io.dhparam.pem")" ]; then
  echo "ipfs/pages filecoin.io ssl dhparam changed"
  reload=1
fi

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

if [ ! -z "$(diff -Naur "$cert_dest/wikipedia-on-ipfs.org.crt" "out/wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/wikipedia-on-ipfs.org.key" "out/wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/wikipedia-on-ipfs.org.trustchain.crt" "out/wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/wikipedia-on-ipfs.org.dhparam.pem" "out/wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/en.wikipedia-on-ipfs.org.crt" "out/en.wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages en.wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/en.wikipedia-on-ipfs.org.key" "out/en.wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages en.wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/en.wikipedia-on-ipfs.org.trustchain.crt" "out/en.wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages en.wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/en.wikipedia-on-ipfs.org.dhparam.pem" "out/en.wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages en.wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/tr.wikipedia-on-ipfs.org.crt" "out/tr.wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages tr.wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/tr.wikipedia-on-ipfs.org.key" "out/tr.wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages tr.wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/tr.wikipedia-on-ipfs.org.trustchain.crt" "out/tr.wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages tr.wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/tr.wikipedia-on-ipfs.org.dhparam.pem" "out/tr.wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages tr.wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/simple.wikipedia-on-ipfs.org.crt" "out/simple.wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages simple.wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/simple.wikipedia-on-ipfs.org.key" "out/simple.wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages simple.wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/simple.wikipedia-on-ipfs.org.trustchain.crt" "out/simple.wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages simple.wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/simple.wikipedia-on-ipfs.org.dhparam.pem" "out/simple.wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages simple.wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ar.wikipedia-on-ipfs.org.crt" "out/ar.wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages ar.wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ar.wikipedia-on-ipfs.org.key" "out/ar.wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages ar.wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ar.wikipedia-on-ipfs.org.trustchain.crt" "out/ar.wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages ar.wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ar.wikipedia-on-ipfs.org.dhparam.pem" "out/ar.wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages ar.wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ku.wikipedia-on-ipfs.org.crt" "out/ku.wikipedia-on-ipfs.org.crt")" ]; then
  echo "ipfs/pages ku.wikipedia-on-ipfs.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ku.wikipedia-on-ipfs.org.key" "out/ku.wikipedia-on-ipfs.org.key")" ]; then
  echo "ipfs/pages ku.wikipedia-on-ipfs.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ku.wikipedia-on-ipfs.org.trustchain.crt" "out/ku.wikipedia-on-ipfs.org.trustchain.crt")" ]; then
  echo "ipfs/pages ku.wikipedia-on-ipfs.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/ku.wikipedia-on-ipfs.org.dhparam.pem" "out/ku.wikipedia-on-ipfs.org.dhparam.pem")" ]; then
  echo "ipfs/pages ku.wikipedia-on-ipfs.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/datatogether.org.crt" "out/datatogether.org.crt")" ]; then
  echo "ipfs/pages datatogether.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/datatogether.org.key" "out/datatogether.org.key")" ]; then
  echo "ipfs/pages datatogether.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/datatogether.org.trustchain.crt" "out/datatogether.org.trustchain.crt")" ]; then
  echo "ipfs/pages datatogether.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/datatogether.org.dhparam.pem" "out/datatogether.org.dhparam.pem")" ]; then
  echo "ipfs/pages datatogether.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saftproject.com.crt" "out/saftproject.com.crt")" ]; then
  echo "ipfs/pages saftproject.com ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saftproject.com.key" "out/saftproject.com.key")" ]; then
  echo "ipfs/pages saftproject.com ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saftproject.com.trustchain.crt" "out/saftproject.com.trustchain.crt")" ]; then
  echo "ipfs/pages saftproject.com ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saftproject.com.dhparam.pem" "out/saftproject.com.dhparam.pem")" ]; then
  echo "ipfs/pages saftproject.com ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saftproject.com.crt" "out/www.saftproject.com.crt")" ]; then
  echo "ipfs/pages www.saftproject.com ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saftproject.com.key" "out/www.saftproject.com.key")" ]; then
  echo "ipfs/pages www.saftproject.com ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saftproject.com.trustchain.crt" "out/www.saftproject.com.trustchain.crt")" ]; then
  echo "ipfs/pages www.saftproject.com ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saftproject.com.dhparam.pem" "out/www.saftproject.com.dhparam.pem")" ]; then
  echo "ipfs/pages www.saftproject.com ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saft-project.org.crt" "out/saft-project.org.crt")" ]; then
  echo "ipfs/pages saft-project.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saft-project.org.key" "out/saft-project.org.key")" ]; then
  echo "ipfs/pages saft-project.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saft-project.org.trustchain.crt" "out/saft-project.org.trustchain.crt")" ]; then
  echo "ipfs/pages saft-project.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/saft-project.org.dhparam.pem" "out/saft-project.org.dhparam.pem")" ]; then
  echo "ipfs/pages saft-project.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saft-project.org.crt" "out/www.saft-project.org.crt")" ]; then
  echo "ipfs/pages www.saft-project.org ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saft-project.org.key" "out/www.saft-project.org.key")" ]; then
  echo "ipfs/pages www.saft-project.org ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saft-project.org.trustchain.crt" "out/www.saft-project.org.trustchain.crt")" ]; then
  echo "ipfs/pages www.saft-project.org ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/www.saft-project.org.dhparam.pem" "out/www.saft-project.org.dhparam.pem")" ]; then
  echo "ipfs/pages www.saft-project.org ssl dhparam changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/peerpad.net.crt" "out/peerpad.net.crt")" ]; then
  echo "ipfs/pages peerpad.net ssl cert changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/peerpad.net.key" "out/peerpad.net.key")" ]; then
  echo "ipfs/pages peerpad.net ssl key changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/peerpad.net.trustchain.crt" "out/peerpad.net.trustchain.crt")" ]; then
  echo "ipfs/pages peerpad.net ssl trustchain changed"
  reload=1
fi

if [ ! -z "$(diff -Naur "$cert_dest/peerpad.net.dhparam.pem" "out/peerpad.net.dhparam.pem")" ]; then
  echo "ipfs/pages peerpad.net ssl dhparam changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "ipfs/pages nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  cp "out/i.ipfs.io.crt" "$cert_dest/i.ipfs.io.crt"
  cp "out/i.ipfs.io.key" "$cert_dest/i.ipfs.io.key"
  cp "out/i.ipfs.io.trustchain.crt" "$cert_dest/i.ipfs.io.trustchain.crt"
  cp "out/i.ipfs.io.dhparam.pem" "$cert_dest/i.ipfs.io.dhparam.pem"
  cp "out/filecoin.io.crt" "$cert_dest/filecoin.io.crt"
  cp "out/filecoin.io.key" "$cert_dest/filecoin.io.key"
  cp "out/filecoin.io.trustchain.crt" "$cert_dest/filecoin.io.trustchain.crt"
  cp "out/filecoin.io.dhparam.pem" "$cert_dest/filecoin.io.dhparam.pem"
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
  cp "out/wikipedia-on-ipfs.org.crt" "$cert_dest/wikipedia-on-ipfs.org.crt"
  cp "out/wikipedia-on-ipfs.org.key" "$cert_dest/wikipedia-on-ipfs.org.key"
  cp "out/wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/en.wikipedia-on-ipfs.org.crt" "$cert_dest/en.wikipedia-on-ipfs.org.crt"
  cp "out/en.wikipedia-on-ipfs.org.key" "$cert_dest/en.wikipedia-on-ipfs.org.key"
  cp "out/en.wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/en.wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/en.wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/en.wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/tr.wikipedia-on-ipfs.org.crt" "$cert_dest/tr.wikipedia-on-ipfs.org.crt"
  cp "out/tr.wikipedia-on-ipfs.org.key" "$cert_dest/tr.wikipedia-on-ipfs.org.key"
  cp "out/tr.wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/tr.wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/tr.wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/tr.wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/simple.wikipedia-on-ipfs.org.crt" "$cert_dest/simple.wikipedia-on-ipfs.org.crt"
  cp "out/simple.wikipedia-on-ipfs.org.key" "$cert_dest/simple.wikipedia-on-ipfs.org.key"
  cp "out/simple.wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/simple.wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/simple.wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/simple.wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/ar.wikipedia-on-ipfs.org.crt" "$cert_dest/ar.wikipedia-on-ipfs.org.crt"
  cp "out/ar.wikipedia-on-ipfs.org.key" "$cert_dest/ar.wikipedia-on-ipfs.org.key"
  cp "out/ar.wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/ar.wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/ar.wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/ar.wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/ku.wikipedia-on-ipfs.org.crt" "$cert_dest/ku.wikipedia-on-ipfs.org.crt"
  cp "out/ku.wikipedia-on-ipfs.org.key" "$cert_dest/ku.wikipedia-on-ipfs.org.key"
  cp "out/ku.wikipedia-on-ipfs.org.trustchain.crt" "$cert_dest/ku.wikipedia-on-ipfs.org.trustchain.crt"
  cp "out/ku.wikipedia-on-ipfs.org.dhparam.pem" "$cert_dest/ku.wikipedia-on-ipfs.org.dhparam.pem"
  cp "out/datatogether.org.crt" "$cert_dest/datatogether.org.crt"
  cp "out/datatogether.org.key" "$cert_dest/datatogether.org.key"
  cp "out/datatogether.org.trustchain.crt" "$cert_dest/datatogether.org.trustchain.crt"
  cp "out/datatogether.org.dhparam.pem" "$cert_dest/datatogether.org.dhparam.pem"
  cp "out/saftproject.com.crt" "$cert_dest/saftproject.com.crt"
  cp "out/saftproject.com.key" "$cert_dest/saftproject.com.key"
  cp "out/saftproject.com.trustchain.crt" "$cert_dest/saftproject.com.trustchain.crt"
  cp "out/saftproject.com.dhparam.pem" "$cert_dest/saftproject.com.dhparam.pem"
  cp "out/www.saftproject.com.crt" "$cert_dest/www.saftproject.com.crt"
  cp "out/www.saftproject.com.key" "$cert_dest/www.saftproject.com.key"
  cp "out/www.saftproject.com.trustchain.crt" "$cert_dest/www.saftproject.com.trustchain.crt"
  cp "out/www.saftproject.com.dhparam.pem" "$cert_dest/www.saftproject.com.dhparam.pem"
  cp "out/saft-project.org.crt" "$cert_dest/saft-project.org.crt"
  cp "out/saft-project.org.key" "$cert_dest/saft-project.org.key"
  cp "out/saft-project.org.trustchain.crt" "$cert_dest/saft-project.org.trustchain.crt"
  cp "out/saft-project.org.dhparam.pem" "$cert_dest/saft-project.org.dhparam.pem"
  cp "out/www.saft-project.org.crt" "$cert_dest/www.saft-project.org.crt"
  cp "out/www.saft-project.org.key" "$cert_dest/www.saft-project.org.key"
  cp "out/www.saft-project.org.trustchain.crt" "$cert_dest/www.saft-project.org.trustchain.crt"
  cp "out/www.saft-project.org.dhparam.pem" "$cert_dest/www.saft-project.org.dhparam.pem"
  cp "out/peerpad.net.crt" "$cert_dest/peerpad.net.crt"
  cp "out/peerpad.net.key" "$cert_dest/peerpad.net.key"
  cp "out/peerpad.net.trustchain.crt" "$cert_dest/peerpad.net.trustchain.crt"
  cp "out/peerpad.net.dhparam.pem" "$cert_dest/peerpad.net.dhparam.pem"

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
