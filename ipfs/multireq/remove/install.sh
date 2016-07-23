#!/usr/bin/env bash

set -e

docker stop multireq >/dev/null || true
docker rm multireq >/dev/null || true
rm -rf /opt/multireq
