#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template "cjdroute.conf.tpl" "out/cjdroute.conf"
