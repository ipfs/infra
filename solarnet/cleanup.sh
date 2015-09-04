#!/bin/sh

for host in `ansible gateway --list-hosts`; do
  echo "==> $host"
  ssh root@$host.i.ipfs.io 'rm -v /var/lib/docker/containers/*/*-json.log ; docker rm $(docker ps -f "status=exited" -aq) ; docker rmi $(docker images -f "dangling=true" -aq)'
done
