#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks if upstart job config changed.
# 2. Rebuilds node_exporter if requested version changed.
# 3. Restarts upstart job if any of the above.
# 4. Checks if nginx.conf changed
# 5. Applies change and reloads nginx
# 6. Rolls back nginx.conf if reload fails
#
# About rolling back nginx.conf:
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

target="/opt/node_exporter"
mkdir -p "$target"

systemd=0
if [ "init-$(ps -o comm= 1)" == "init-systemd" ]; then
  systemd=1
fi

rebuild=0
restart=0

ref=$(lookup node_exporter_ref)
actual_ref=$(cat $target/current.ref || true)

if [ "ref$ref" != "ref$actual_ref" ]; then
  rebuild=1
fi

if [ "systemd$systemd" == "systemd1" ]; then
  if [ ! -z "$(git diff "/lib/systemd/system/node_exporter.service" "systemd.service" 2>&1 || echo "new")" ]; then
    echo "metrics/node_exporter systemd service changed"
    restart=1
  fi
else
  if [ ! -z "$(git diff "/etc/init/node_exporter.conf" "upstart.conf" 2>&1 || echo "new")" ]; then
    echo "metrics/node_exporter upstart config changed"
    restart=1
  fi
fi

if [ "rebuild$rebuild" == "rebuild1" ]; then
  echo "metrics/node_exporter rebuilding"
  go get -d github.com/prometheus/node_exporter
  cd $GOPATH/src/github.com/prometheus/node_exporter/
  git remote set-url origin https://github.com/prometheus/node_exporter
  git remote prune origin >/dev/null
  git gc
  git fetch -q --all
  git reset -q --hard "$ref"
  make build >/dev/null
  mv ./node_exporter /usr/bin/node_exporter
  cd -
  echo "$actual_ref" > "$target/previous.ref"
  echo "$ref" > "$target/current.ref"
  echo "metrics/node_exporter executable changed"
  restart=1
fi

if [ "restart$restart" == "restart1" ]; then
  echo "metrics/node_exporter restarting"
  if [ "systemd$systemd" == "systemd1" ]; then
    cp systemd.service /lib/systemd/system/node_exporter.service
    systemctl daemon-reload
    systemctl restart node_exporter
  else
    cp upstart.conf /etc/init/node_exporter.conf
    service node_exporter stop >/dev/null || true
    service node_exporter start >/dev/null
  fi
fi

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/7-node-exporter.conf"
nginx_checkpoint="/opt/node_exporter/nginx.conf"

mkdir -p "$(dirname "$nginx_dest")"
mkdir -p "$(dirname "$nginx_checkpoint")"

reload=0
if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "metrics/node_exporter nginx.conf changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "metrics/node_exporter nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload')

  if echo $out | grep failed >/dev/null; then
    echo $out
    # Reload failed, roll back.
    cp "$nginx_checkpoint" "$nginx_dest" || true
    exit 1
  fi

  # Sucessfully reloaded, now "commit" the checkpoint file.
  cp "$nginx_src" "$nginx_checkpoint"
fi
