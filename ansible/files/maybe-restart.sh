#!/bin/sh

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <0-100> <cmd> [<args>...]"
  echo "  run command <cmd> with a given percent probability"
  exit 1
fi

chance=$1
shift

random=`hexdump -n 2 -e '/2 "%u"' /dev/urandom`

[ `expr $random % 100` -lt "$chance" ] && eval "$@"
