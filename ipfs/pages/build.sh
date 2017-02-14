#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf

printf %s\\n "$(lookup pages_orbit_ssl_cert)" > out/orbit.chat.crt
printf %s\\n "$(lookup pages_orbit_ssl_key)" > out/orbit.chat.key
printf %s\\n "$(lookup pages_orbit_ssl_trustchain)" > out/orbit.chat.trustchain.crt
printf %s\\n "$(lookup pages_orbit_ssl_dhparam)" > out/orbit.chat.dhparam.pem
