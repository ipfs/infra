#!/usr/bin/env bash

set -e

printf %s\\n "$(lookup ssh_keys)" > authorized_keys
