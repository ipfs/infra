#!/usr/bin/env bash

mkdir -p out/
name=ipfs provsn_template "config.tpl" "out/ipfs.config"
name=ipfs_v03x provsn_template "config.tpl" "out/ipfs_v03x.config"

cat > out/ipfs.opts <<-EOF
-d
--name ipfs
--restart always
--net host
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v $(lookup ipfs_repo):/ipfs
ipfs:$(lookup ipfs_ref | head -c 7)
EOF

cat > out/ipfs_v03x.opts <<-EOF
-d
--name ipfs_v03x
--restart always
--net host
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v $(lookup ipfs_v03x_repo):/ipfs
ipfs_v03x:$(lookup ipfs_v03x_ref | head -c 7)
EOF
