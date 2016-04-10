#!/usr/bin/env bash

provsn_hosts=(spacerock pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal phobos deimos)
provsn_groups=()

all_ssh_options="-o ConnectTimeout=5"
all_omit_build=(secrets/ipfs)

baseunits=(base docker mtail)
gatewayunits=(ipfs ipfs/multireq secrets/ipfs)

spacerock_ssh="root@46.101.117.27"
spacerock_units=(${baseunits[@]} ${gatewayunits[@]})
otherrock_ssh="root@46.101.233.94"
otherrock_units=(${baseunits[@]} ${gatewayunits[@]})

pluto_ssh="root@104.236.179.241"
pluto_units=(${baseunits[@]} ${gatewayunits[@]})

neptune_ssh="root@104.236.176.52"
neptune_units=(${baseunits[@]} ${gatewayunits[@]})

uranus_ssh="root@162.243.248.213"
uranus_units=(${baseunits[@]} ${gatewayunits[@]})

saturn_ssh="root@128.199.219.111"
saturn_units=(${baseunits[@]} ${gatewayunits[@]})

jupiter_ssh="root@104.236.151.122"
jupiter_units=(${baseunits[@]} ${gatewayunits[@]})

venus_ssh="root@104.236.76.40"
venus_units=(${baseunits[@]} ${gatewayunits[@]})

earth_ssh="root@178.62.158.247"
earth_units=(${baseunits[@]} ${gatewayunits[@]})

mercury_ssh="root@178.62.61.185"
mercury_units=(${baseunits[@]} ${gatewayunits[@]})

pollux_ssh="root@5.9.59.34"
pollux_units=(${baseunits[@]} ipfs)

biham_ssh="root@188.40.114.11"
biham_units=(${baseunits[@]} ipfs)

nihal_ssh="root@188.40.116.66"
nihal_units=(${baseunits[@]} ipfs)

phobos_ssh="root@104.131.3.162"
phobos_units=(${baseunits[@]})

deimos_ssh="root@46.101.230.158"
deimos_units=(${baseunits[@]})
