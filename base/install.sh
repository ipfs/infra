#!/usr/bin/env bash

set -e

dir="$HOME/.ssh"
if [ ! -z "$(git diff "$dir/authorized_keys" authorized_keys || echo new)" ]; then
  echo "$unit authorized_keys changed"
  mkdir -p "$dir"
  chmod 700 "$dir"
  cp authorized_keys "$dir/authorized_keys"
  chmod 400 "$dir/authorized_keys"
fi

pkgs=(mosh tmux screen gdb vim tree htop iftop sysstat bridge-utils unzip jq)
pkgs+=(git mercurial nodejs npm build-essential autoconf libtool bison flex)
apt-get install -qq -y "${pkgs[@]}"

if [ ! -e "/usr/bin/node" ]; then
  echo "linking nodejs => node (thanks ubuntu)"
  ln -s "$(which nodejs)" /usr/bin/node
fi

if [ "$host" != "$(hostname)" ]; then
  echo "setting hostname"
  hostname "$host"
  echo "$host" > /etc/hostname
fi
