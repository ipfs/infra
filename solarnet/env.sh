#!/usr/bin/env bash

provsn_hosts=(spacerock pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal phobos deimos)
provsn_groups=()

all_ssh_options="-o ConnectTimeout=5"
all_omit_build=(secrets/ipfs)

baseunits=(base docker)
gatewayunits=(ipfs ipfs/multireq secrets/ipfs)

spacerock_ssh="root@spacerock.i.ipfs.team"
spacerock_units=(${baseunits[@]} ${gatewayunits[@]})

pluto_ssh="root@pluto.i.ipfs.io"
pluto_units=(${baseunits[@]} ${gatewayunits[@]})

neptune_ssh="root@neptune.i.ipfs.io"
neptune_units=(${baseunits[@]} ${gatewayunits[@]})

uranus_ssh="root@uranus.i.ipfs.io"
uranus_units=(${baseunits[@]} ${gatewayunits[@]})

saturn_ssh="root@saturn.i.ipfs.io"
saturn_units=(${baseunits[@]} ${gatewayunits[@]})

jupiter_ssh="root@jupiter.i.ipfs.io"
jupiter_units=(${baseunits[@]} ${gatewayunits[@]})

venus_ssh="root@venus.i.ipfs.io"
venus_units=(${baseunits[@]} ${gatewayunits[@]})

earth_ssh="root@earth.i.ipfs.io"
earth_units=(${baseunits[@]} ${gatewayunits[@]})

mercury_ssh="root@mercury.i.ipfs.io"
mercury_units=(${baseunits[@]} ${gatewayunits[@]})

pollux_ssh="root@pollux.i.ipfs.io"
pollux_units=(${baseunits[@]})

biham_ssh="root@biham.i.ipfs.io"
biham_units=(${baseunits[@]})

nihal_ssh="root@nihal.i.ipfs.io"
nihal_units=(${baseunits[@]})

phobos_ssh="root@phobos.i.ipfs.io"
phobos_units=(${baseunits[@]})

deimos_ssh="root@deimos.i.ipfs.io"
deimos_units=(${baseunits[@]})
