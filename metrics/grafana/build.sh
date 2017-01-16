#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template grafana.ini.tpl out/grafana.ini
provsn_template nginx.conf.tpl out/nginx.conf

cat > out/docker.opts <<-EOF
-d
--name grafana
--restart always
--net host
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v /opt/grafana/config:/etc/grafana
-v /opt/grafana/data:/var/lib/grafana
grafana/grafana:$(lookup grafana_ref)
EOF
