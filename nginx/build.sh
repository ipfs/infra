#!/usr/bin/env bash

set -e

mkdir -p out/
cp nginx.conf out/nginx.conf
cp 451.html out/451.html

cat > out/docker.opts <<-EOF
-d
--name nginx
--restart always
--net host
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v /opt/nginx/conf.d:/etc/nginx/conf.d:ro
-v /opt/nginx/certs:/etc/nginx/certs:ro
-v /opt/nginx/logs:/var/log/nginx
-v /opt/nginx/html:/usr/share/nginx/html:ro
nginx:$(lookup nginx_ref)
EOF
