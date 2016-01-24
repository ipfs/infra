#!/usr/bin/env bash

provsn_hosts=(spacerock)
provsn_groups=()

all_ssh_options="-o ConnectTimeout=5"
all_omit_build=(secrets/ipfs)

baseunits=(base docker)

spacerock_ssh="root@spacerock.i.ipfs.team"
spacerock_units=(${baseunits[@]} ipfs ipfs/multireq secrets/ipfs)
