#!/usr/bin/env bash

set -e

# How this install script works
#
# 1. Checks if requested version changed
# 2. Downloads and installs new version
# 3. Installs /etc/profile script for $GOPATH et. al.

target="/opt/golang"

reinstall=0

version=$(lookup golang_version)
tarball="$version.linux-amd64.tar.gz"
tarball_url="https://storage.googleapis.com/golang/$tarball"
goroot=$(lookup golang_goroot)

actual_version=$($goroot/bin/go version | cut -d' ' -f3 || true)
if [ "$version" != "$actual_version" ]; then
  reinstall=1
fi

if [ "reinstall$reinstall" == "reinstall1" ]; then
  wget -N -q "$tarball_url"
  if ! md5sum "$tarball" | grep "$checksum" > /dev/null; then
    echo "golang $version download failed or checksum mismatch"
    exit 1
  fi

  echo "golang unpacking $version"
  rm -rf "$goroot" "$HOME/go/pkg"
  tar -C $(dirname "$goroot") -xf "$tarball"
fi

cp "profile.sh" "/etc/profile.d/golang.sh"
. profile.sh
