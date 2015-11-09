#!/bin/sh

keyfile="$HOME/.protocol/solarnet.key"
if [ -f $keyfile ] ; then
  echo "Reading key from $keyfile"
  key=$(cat $keyfile)
else
  echo "Reading key from stdin"
  read key
fi

if [ "$1" = "-e" ] ; then
  cd secrets_plaintext/
  for f in * ; do
    echo "secrets_plaintext/$f => secrets/$f"
    cat $f | senc -e -k "$key" > ../secrets/$f
  done
elif [ "$1" = "-d" ] ; then
  mkdir -p secrets_plaintext/
  cd secrets/
  for f in * ; do
    echo "secrets/$f => secrets_plaintext/$f"
    cat $f | senc -d -k "$key" > ../secrets_plaintext/$f
  done
else
  echo "usage: echo \$key | ./secrets.sh -e|-d"
fi
