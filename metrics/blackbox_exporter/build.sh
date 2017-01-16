#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf
provsn_template config.yml.tpl out/config.yml

cat > out/docker.opts <<-EOF
-d
--name blackbox_exporter
--restart always
-p 127.0.0.1:9115:9115
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v /opt/blackbox_exporter/config.yml:/etc/blackbox_exporter.yml
blackbox_exporter:$(lookup blackbox_exporter_ref)
-config.file=/etc/blackbox_exporter.yml
EOF

