#!/usr/bin/env bash

set -e

cat > docker.opts <<-EOF
-d
--name mtail
--restart always
-p 127.0.0.1:3903:3903
--volume /opt/nginx/logs:/mtail/logs
--volume /opt/mtail/progs:/mtail/progs
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
mtail:$(lookup mtail_ref)
access.log
EOF
