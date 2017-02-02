#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks if nginx.conf changed
# 2. Applies change and reloads nginx
# 3. Rolls back nginx.conf if reload fails
#
# About rolling back nginx.conf:
#
# We don't check against the file actually used by nginx,
# but instead against another copy, which acts as a kind of checkpoint.
# We update the checkpoint copy only after successfully reloading nginx.
# That way, if reloading fails for any reason, the next run will attempt again.

nginx_src="out/nginx.conf"
nginx_dest="/opt/nginx/conf.d/5-jenkins.conf"
nginx_checkpoint="/opt/jenkins/nginx.conf"

mkdir -p "$(dirname "$nginx_dest")"
mkdir -p "$(dirname "$nginx_checkpoint")"

reload=0
if [ ! -z "$(diff -Naur "$nginx_checkpoint" "$nginx_src")" ]; then
  echo "ci/jenkins nginx.conf changed"
  reload=1
fi

if [ "reload$reload" == "reload1" ]; then
  echo "ci/jenkins nginx reloading"

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
