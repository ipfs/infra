#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template prometheus.yml.tpl out/prometheus.yml

cat > out/docker.opts <<-EOF
-d
--name prometheus
--restart always
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
--net host
-v /opt/prometheus/config:/etc/prometheus
-v /opt/prometheus/data:/prometheus
prometheus:$(lookup prometheus_ref)
-config.file=/etc/prometheus/prometheus.yml
-storage.local.path=/prometheus
-web.console.libraries=/etc/prometheus/console_libraries
-web.console.templates=/etc/prometheus/consoles"
-web.listen-address=127.0.0.1:9090
$(lookup prometheus_opts)
EOF
