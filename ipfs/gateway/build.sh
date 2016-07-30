#!#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf out/6-ipfs-gateway.conf
