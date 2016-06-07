#!#!/usr/bin/env bash

set -e

mkdir -p out/
printf %s\\n "$(lookup ssl_cert)" > out/ipfs.io.crt
printf %s\\n "$(lookup ssl_key)" > out/ipfs.io.key
printf %s\\n "$(lookup ssl_trustchain)" > out/ipfs.io.trustchain.crt
printf %s\\n "$(lookup ssl_dhparam)" > out/dhparam.pem
cp nginx.conf out/0-ssl.conf
