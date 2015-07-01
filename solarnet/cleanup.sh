#!/bin/sh

ansible solarnet -f 4 -m shell -a 'rm -v /var/lib/docker/containers/*/*-json.log ; docker restart ipfs ; sleep 2 ; docker rm $(docker ps -f "status=exited" -aq) ; docker rmi $(docker images -f "dangling=true" -aq)'
