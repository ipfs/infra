#!/usr/bin/env bash

all_ipfs_git=git://github.com/ipfs/go-ipfs
all_ipfs_ref="bae3d73e07fc27eb9c8ca819b3f2faf319d9e218"

# storage hosts, coordinate ipfs deploys with storage users (e.g. @davidar, @substack)
biham_ipfs_ref=bae3d73e07fc27eb9c8ca819b3f2faf319d9e218
pollux_ipfs_ref=bae3d73e07fc27eb9c8ca819b3f2faf319d9e218
nihal_ipfs_ref=bae3d73e07fc27eb9c8ca819b3f2faf319d9e218
auva_ipfs_ref=bae3d73e07fc27eb9c8ca819b3f2faf319d9e218

all_ipfs_daemon_opts="--enable-gc --enable-pubsub-experiment"

# Network ports. See config.tpl for how they are bound.
# Also see build.sh for the Docker networking options used.
all_ipfs_swarm_tcp=4001
all_ipfs_swarm_utp=4002
all_ipfs_swarm_ws=8081
all_ipfs_api=5001
all_ipfs_gateway=8080

# Connection management. Closes unused connections to save resources.
all_ipfs_connmgr_period="1m"
all_ipfs_connmgr_highwater="2000"
all_ipfs_connmgr_lowwater="1500"

# Identities of the nodes. The private keys are hidden away in the secrets unit.
pluto_ipfs_peerid="QmSoLPppuBtQSGwKDZT2M73ULpjvfd3aZ6ha4oFGL1KrGM"
neptune_ipfs_peerid="QmSoLnSGccFuZQJzRadHn95W2CrSFmZuTdDWP8HXaHca9z"
uranus_ipfs_peerid="QmSoLueR4xBeUbY9WZ9xGUUxunbKWcrNFTDAadQJmocnWm"
saturn_ipfs_peerid="QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu"
jupiter_ipfs_peerid="QmSoLju6m7xTh3DuokvT3886QRYqxAzb1kShaanJgW36yx"
venus_ipfs_peerid="QmSoLV4Bbm51jM9C4gDYZQ9Cy3U6aXMJDAbzgu2fzaDs64"
earth_ipfs_peerid="QmSoLer265NRgSp2LA3dPaeykiS1J6DifTC88f5uVQKNAd"
mercury_ipfs_peerid="QmSoLMeWqB7YGVLJN3pNLQpmmEk35v6wYtsMGLzSr5QBU3"
scrappy_ipfs_peerid="Qmbut9Ywz9YEDrz8ySBSgWyJk41Uvm2QJPhwDJzJyGFsD6"
chappy_ipfs_peerid="QmZMxNdpMkewiVZLMRxaNxUeZpDUb34pWjZ1kZvsd16Zic"
pollux_ipfs_peerid="QmRv1GNseNP1krEwHDjaQMeQVJy41879QcDwpJVhY8SWve"
biham_ipfs_peerid="QmZY7MtK8ZbG1suwrxc7xEYZ2hQLf1dAWPRHhjxC8rjq8E"
nihal_ipfs_peerid="QmepgFW7BHEtU4pZJdxaNiv75mKLLRQnPi1KaaXmQN4V1a"
auva_ipfs_peerid="QmZSe5GZJb5jcKQZzQmdWaFtimTHafjvtxyMMTJy5nZ6hN"

# Repo settings (aka fs-repo)
# Historical location, TODO: move to /mnt/data/ipfs
all_ipfs_repo=/ipfs/ipfs_master/repo

# The datastore lookup cache - 512KiB
all_ipfs_bloom_size=524288
# 128MiB for storage hosts, should be good for up to about 200M objects
biham_ipfs_bloom_size=134217728
pollux_ipfs_bloom_size=134217728
nihal_ipfs_bloom_size=134217728
auva_ipfs_bloom_size=134217728

# Sharding on add
all_ipfs_enable_sharding=false
auva_ipfs_enable_sharding=true

# Once an hour, the daemon checks whether repo size is above 90% of 60G,
# and runs GC if it is.
all_ipfs_gc_period=1h
all_ipfs_gc_watermark=90
all_ipfs_gc_capacity=60G
scrappy_ipfs_gc_capacity=1000G
chappy_ipfs_gc_capacity=1000G

# On the storage nodes, we don't automatically run GC.
pollux_ipfs_gc_period=0s
biham_ipfs_gc_period=0s
nihal_ipfs_gc_period=0s
auva_ipfs_gc_period=0s
