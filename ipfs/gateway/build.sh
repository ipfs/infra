#!#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf out/6-ipfs-gateway.conf

printf %s\\n "$(lookup ssl_cert)" > out/ipfs.io.crt
printf %s\\n "$(lookup ssl_key)" > out/ipfs.io.key
printf %s\\n "$(lookup ssl_trustchain)" > out/ipfs.io.trustchain.crt
printf %s\\n "$(lookup ssl_dhparam)" > out/dhparam.pem
