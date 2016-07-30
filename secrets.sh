#!/bin/sh

keyfile="$HOME/.protocol/solarnet.key"
if [ -f $keyfile ] ; then
  echo "Reading key from $keyfile"
  key=$(cat $keyfile)
else
  echo "error: no keyfile at $keyfile"
  exit 1
fi

if [ "$1" = "-e" ] ; then
  mkdir secrets/
  cd secrets/
  for f in * ; do
    echo "secrets/$f => secrets_secure/$f"
    cat $f | senc -e -k "$key" > ../secrets_secure/$f
  done
elif [ "$1" = "-d" ] ; then
  mkdir -p secrets/
  cd secrets_secure/
  for f in * ; do
    echo "secrets_secure/$f => secrets/$f"
    cat $f | senc -d -k "$key" > ../secrets/$f
  done
else
  echo "usage: ./secrets.sh -e|-d"
fi
