#!/usr/bin/env bash

set -e

docker stop ipfs_v03x >/dev/null || true
docker rm ipfs_v03x >/dev/null || true
rm -rf /opt/ipfs_v03x /ipfs/ipfs_master/repo_v2
