#!/usr/bin/env bash

mkdir -p out/
provsn_template "config.tpl" "out/config"

cat > out/ipfs.opts <<-EOF
-d
--name ipfs
--restart always
-p 0.0.0.0:$(lookup ipfs_swarm_tcp):4001
-p 0.0.0.0:$(lookup ipfs_swarm_utp):4002/udp
-p 127.0.0.1:$(lookup ipfs_api):5001
-p 127.0.0.1:$(lookup ipfs_gateway):8080
-v $(lookup ipfs_repo):/ipfs
ipfs:$(lookup ipfs_ref | head -c 7)
EOF

cat > out/ipfs_v03x.opts <<-EOF
-d
--name ipfs_v03x
--restart always
-p 0.0.0.0:$(lookup ipfs_v03x_swarm_tcp):4001
-p 0.0.0.0:$(lookup ipfs_v03x_swarm_utp):4002/udp
-p 127.0.0.1:$(lookup ipfs_v03x_api):5001
-p 127.0.0.1:$(lookup ipfs_v03x_gateway):8080
-v $(lookup ipfs_v03x_repo):/ipfs
ipfs_v03x:$(lookup ipfs_v03x_ref | head -c 7)
EOF
