#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template grafana.ini.tpl out/grafana.ini
provsn_template nginx.conf.tpl out/nginx.conf

cat > out/docker.opts <<-EOF
-d
--name grafana
--restart always
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-p 127.0.0.1:3000:3000
-v /opt/grafana/config:/etc/grafana
-v /opt/grafana/data:/var/lib/grafana
grafana/grafana:$(lookup grafana_ref)
EOF
