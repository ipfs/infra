#!/usr/bin/env bash

set -e

cat > docker.opts <<-EOF
-d
--name multireq
--restart always
--net host
multireq:$(lookup multireq_ref)
127.0.0.1:8040
http://127.0.0.1:$(lookup ipfs_gateway)
http://127.0.0.1:$(lookup ipfs_v03x_gateway)
EOF
