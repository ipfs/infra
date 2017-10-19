#!/usr/bin/env bash

set -e

# TODO add nodesource repo
pkgs=(mosh tmux screen gdb vim tree htop iftop sysstat bridge-utils unzip jq mtr traceroute dnsutils psmisc)
pkgs+=(git mercurial nodejs build-essential autoconf libtool bison flex devscripts)
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confold install -qq -y "${pkgs[@]}"

if [ ! -e "/usr/bin/node" ]; then
  echo "linking nodejs => node (thanks ubuntu)"
  ln -s "$(which nodejs)" /usr/bin/node
fi

if [ "$host" != "$(hostname)" ]; then
  echo "setting hostname"
  hostname "$host"
  echo "$host" > /etc/hostname
fi

dir="$HOME/.ssh"
if [ ! -z "$(git diff "$dir/authorized_keys" authorized_keys || echo new)" ]; then
  echo "$unit authorized_keys changed"
  mkdir -p "$dir"
  chmod 700 "$dir"
  cp authorized_keys "$dir/authorized_keys"
  chmod 400 "$dir/authorized_keys"
fi
