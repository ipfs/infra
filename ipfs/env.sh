#!/usr/bin/env bash

all_ipfs_git=git://github.com/ipfs/go-ipfs
all_ipfs_ref=994109c7316166fe89e6f4df91b91ca93283691c
# TODO: move to /mnt/data/ipfs
all_ipfs_repo=/ipfs/ipfs_master/repo
all_ipfs_swarm_tcp=4001
all_ipfs_swarm_utp=4002
all_ipfs_api=5001
all_ipfs_gateway=8080

pluto_ipfs_ref=bc6d71f4cdea90f61b0c9f2d1a68c6474e4c65b9

# storage hosts, coordinate ipfs deploys with storage users (e.g. @davidar)
biham_ipfs_ref=f3d5fe6c6518b44d82c5e77cb34e7f6f0168d82d
pollux_ipfs_ref=bc6d71f4cdea90f61b0c9f2d1a68c6474e4c65b9
nihal_ipfs_ref=994109c7316166fe89e6f4df91b91ca93283691c

# canaries (@whyrusleeping)
# XXX should one of these be a gateway?
mercury_ipfs_ref=bc6d71f4cdea90f61b0c9f2d1a68c6474e4c65b9
neptune_ipfs_ref=bc6d71f4cdea90f61b0c9f2d1a68c6474e4c65b9

all_ipfs_v03x_git=git://github.com/ipfs/go-ipfs
all_ipfs_v03x_ref=b21cff6f3efacb5578a2521e2ff27b4c10678c03
# TODO: move to /mnt/data/ipfs_v03x
all_ipfs_v03x_repo=/ipfs/ipfs_master/repo_v2
all_ipfs_v03x_api=15001
all_ipfs_v03x_gateway=18080
all_ipfs_v03x_swarm_tcp=14001
all_ipfs_v03x_swarm_utp=14002

all_ipfs_gc_period=1h
all_ipfs_gc_watermark=90
all_ipfs_gc_capacity=30G

earth_ipfs_swarm_tcp=14001
earth_ipfs_swarm_utp=14002
earth_ipfs_v03x_swarm_tcp=4001
earth_ipfs_v03x_swarm_utp=4002
saturn_ipfs_swarm_tcp=14001
saturn_ipfs_swarm_utp=14002
saturn_ipfs_v03x_swarm_tcp=4001
saturn_ipfs_v03x_swarm_utp=4002
venus_ipfs_swarm_tcp=14001
venus_ipfs_swarm_utp=14002
venus_ipfs_v03x_swarm_tcp=4001
venus_ipfs_v03x_swarm_utp=4002

pollux_ipfs_gc_period=0s
biham_ipfs_gc_period=0s
nihal_ipfs_gc_period=0s
