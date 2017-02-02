#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf
