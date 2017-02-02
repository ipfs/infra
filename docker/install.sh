#!/usr/bin/env bash

set -e

systemd=0
if [ "init-$(ps -o comm= 1)" == "init-systemd" ]; then
  systemd=1
fi

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
  if [ "systemd$systemd" == "systemd1" ]; then
    systemctl restart docker
  else
    cmd=restart
    service docker status | grep start >/dev/null || cmd=start
    service docker status | grep stop >/dev/null || cmd=restart
    service docker "$cmd"
  fi

  cp config "$target/config"
fi
