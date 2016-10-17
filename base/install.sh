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

pkgs=()
which mosh >/dev/null || pkgs+=(mosh)
which vim >/dev/null || pkgs+=(vim)
which htop >/dev/null || pkgs+=(htop)
which screen >/dev/null || pkgs+=(screen)
which bridge-utils >/dev/null || pkgs+=(bridge-utils)
which build-essential >/dev/null || pkgs+=(build-essential)
which autoconf >/dev/null || pkgs+=(autoconf)
which libtool >/dev/null || pkgs+=(libtool)
which bison >/dev/null || pkgs+=(bison)
which flex >/dev/null || pkgs+=(flex)
which nodejs >/dev/null || pkgs+=(nodejs)
which npm >/dev/null || pkgs+=(npm)
which mercurial >/dev/null || pkgs+=(mercurial)
which git >/dev/null || pkgs+=(git)
which sysstat >/dev/null || pkgs+=(sysstat)
which iftop >/dev/null || pkgs+=(iftop)
which tmux >/dev/null || pkgs+=(tmux)
which unzip >/dev/null || pkgs+=(unzip)
which jq >/dev/null || pkgs+=(jq)
which gdb >/dev/null || pkgs+=(gdb)
which tree >/dev/null || pkgs+=(tree)

if [ ! -z "${pkgs}" ]; then
  apt-get install -qq -y "${pkgs[@]}"
fi

if [ "$host" != "$(hostname)" ]; then
  echo "setting hostname"
  hostname "$host"
  echo "$host" > /etc/hostname
fi
