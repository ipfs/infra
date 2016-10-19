#!/usr/bin/env bash

set -e

# How this install script works
#
# Checks if the config changed, applies the change, reloads nginx if neccessary.
# Rolls back the change if reloading fails.
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/7-grafana.conf"
nginx_checkpoint="/opt/grafana/nginx.conf"

mkdir -p "$(basename "$nginx_dest")"
mkdir -p "$(basename "$nginx_checkpoint")"

reload=0
if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "metrics/grafana nginx config changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "metrics/grafana nginx reloading"

  cp "$nginx_src" "$nginx_dest"
  out=$(docker exec nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload' 2>/dev/null)

  if echo $out | grep failed >/dev/null; then
    echo $out
    # reload failed, roll back
    cp "$nginx_checkpoint" "$nginx_dest" || true
    exit 1
  fi

  # sucessfully reloaded, now "commit" the checkpoint file
  cp "$nginx_src" "$nginx_checkpoint"
fi
