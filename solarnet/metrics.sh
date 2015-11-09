#!/bin/sh

proxy=root@earth.i.ipfs.io
target=metrics.i.ipfs.io:80
localport=8080

usage() {
  echo "usage: $0 [<proxy>] [<target>] [<localport>]"
  echo "proxy through to a target "
  exit 1
}

die() {
  echo "error: $@"
  exit 1
}

if [ $# -ge 1 ]; then
  proxy="$1"
fi

if [ $# -ge 2 ]; then
  target="$2"
fi

if [ $# -ge 3 ]; then
  localport="$3"
fi

# set up local url
localurl="http://localhost:$localport"

# setup proxy
echo "setting up proxy through $proxy"
ssh "$proxy" -N -L "$localport:$target" &
sid="$!"

kill -0 "$!" || die "failed to log into $proxy"

cleanup() {
  echo "stopping..."
  kill "$sid"
  exit
}

trap cleanup INT TERM

# use proxy
echo "proxying $localurl -> $proxy -> $target"

# open
echo "open $localurl"
open "$localurl"

# wait forever
echo "enter ^C to stop"
tail -f /dev/null
