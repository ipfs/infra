#!/usr/bin/env bash

set -e

target="/opt/cjdns"
[ ! -d  "$target/.git" ] || rm -rf "$target"
mkdir -p "$target"

systemd=0
if [ "init-$(ps -o comm= 1)" == "init-systemd" ]; then
  systemd=1
fi

restart=0

if [ ! -z "$(diff -Naur "/etc/cjdroute.conf" "out/cjdroute.conf")" ]; then
  echo "cjdns config changed"
  restart=1
fi

if [ "systemd$systemd" == "systemd1" ]; then
  if [ ! -z "$(git diff "/lib/systemd/system/cjdns.service" "systemd.service" 2>&1 || echo "new")" ]; then
    echo "cjdns systemd service changed"
    restart=1
  fi
else
  if [ ! -z "$(git diff "/etc/init/cjdns.conf" "upstart.conf" 2>&1 || echo "new")" ]; then
    echo "cjdns upstart config changed"
    restart=1
  fi
fi

ref=$(lookup cjdns_ref)
actual_ref=$(cat "$target/ref" 2>/dev/null || echo -n nothing)

if [ "ref$ref" != "ref$actual_ref" ]; then
  echo "cjdns building, ref changed from [$actual_ref] to [$ref]"

  [ -d "$target/src/.git" ] || git clone -q $(lookup cjdns_git) "$target/src"
  cd "$target/src"
  git remote set-url origin $(lookup cjdns_git)
  git remote prune origin >/dev/null
  git gc
  git fetch -q --all
  git --work-tree="$target/src" reset -q --hard "$ref"

  ./clean && 2>&1 >/dev/null
  ./do 2>&1 >/dev/null
  ./cjdroute --version >/dev/null

  rm -f "$target/cjdroute.*"
  mv /usr/bin/cjdroute "$target/cjdroute.$actual_ref" 2>/dev/null || true
  cp cjdroute /usr/bin/cjdroute

  cd - >/dev/null
  echo "$ref" > "$target/ref"
  restart=1
fi

if [ "restart$restart" == "restart1" ]; then
  cp -a "out/cjdroute.conf" "/etc/cjdroute.conf"
  chmod 400 /etc/cjdroute.conf

  echo "cjdns restarting"
  if [ "systemd$systemd" == "systemd1" ]; then
    cp systemd.service /lib/systemd/system/cjdns.service
    systemctl daemon-reload
    systemctl is-enabled cjdns || systemctl enable cjdns
    systemctl restart cjdns
  else
    cp upstart.conf /etc/init/cjdns.conf
    cmd=restart
    service cjdns status | grep start >/dev/null || cmd=start
    service cjdns status | grep stop >/dev/null || cmd=restart
    service cjdns "$cmd"
  fi
fi
