#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template "service.json.tpl" "out/ipfs-cluster_service.json"

cat > out/ipfs-cluster.opts <<-EOF
-d
--name ipfs-cluster
--restart always
--net host
--env IPFS_CLUSTER_PATH=/data/ipfs-cluster
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v $(lookup ipfs_cluster_data):/data/ipfs-cluster
ipfs-cluster:$(lookup ipfs_cluster_ref | head -c 7)
EOF
