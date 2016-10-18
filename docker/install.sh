#!/usr/bin/env bash

set -e

which docker >/dev/null || ./getdocker.sh

restart=0

target=/opt/docker
mkdir -p "$target"

if [ ! -z "$(git diff "$target/config" "config" 2>&1 || echo "new")" ]; then
  echo "docker config changed"
  restart=1
fi

cp config /etc/default/docker

if [ "restart$restart" == "restart1" ]; then
  echo "docker restarting"
  # TODO systemd
  restart docker 2>&1 >/dev/null || start docker >/dev/null
  cp config "$target/config"
fi
