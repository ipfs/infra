#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf

printf %s\\n "$(lookup ci_ssl_cert)" > out/ci.ipfs.team.crt
printf %s\\n "$(lookup ci_ssl_key)" > out/ci.ipfs.team.key
printf %s\\n "$(lookup ci_ssl_trustchain)" > out/ci.ipfs.team.trustchain.crt
printf %s\\n "$(lookup ci_ssl_dhparam)" > out/ci.ipfs.team.dhparam.pem
