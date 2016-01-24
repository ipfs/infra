#!/usr/bin/env bash

set -e

dir="$HOME/.ssh"
if [ ! -z "$(git diff "$dir/authorized_keys" authorized_keys || echo new)" ]; then
  echo "$host: $unit authorized_keys changed"
  mkdir -p "$dir"
  chmod 700 "$dir"
  cp authorized_keys "$dir/authorized_keys"
  chmod 400 "$dir/authorized_keys"
fi

pkgs=()
which htop >/dev/null || pkgs+=(htop)
which iftop >/dev/null || pkgs+=(iftop)
which mosh >/dev/null || pkgs+=(mosh)
which screen >/dev/null || pkgs+=(screen)
which tmux >/dev/null || pkgs+=(tmux)
which git >/dev/null || pkgs+=(git)
which jq >/dev/null || pkgs+=(jq)

if [ ! -z "${pkgs}" ]; then
  apt-get install -qq -y "${pkgs[@]}"
fi
