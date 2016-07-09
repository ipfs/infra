#!/usr/bin/env bash

provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal phobos deimos rigel)
# provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal)
# provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury)
provsn_groups=()

all_ssh_options="-o ConnectTimeout=30"
all_omit_build=(secrets/ipfs secrets/cjdns secrets/ssl)

baseunits=(base docker nginx mtail)
gatewayunits=(ipfs ipfs/v03x ipfs/multireq secrets/ipfs ssl secrets/ssl)
storageunits=(ipfs secrets/ipfs)

# digitalocean-sfo1
pluto_ssh="root@104.236.179.241"
pluto_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sfo1
neptune_ssh="root@104.236.176.52"
neptune_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-nyc2
uranus_ssh="root@162.243.248.213"
uranus_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sgp1
saturn_ssh="root@128.199.219.111"
saturn_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sfo1
jupiter_ssh="root@104.236.151.122"
jupiter_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-nyc3, A ipfs.io
venus_ssh="root@104.236.76.40"
venus_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-ams2, A ipfs.io
earth_ssh="root@178.62.158.247"
earth_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-lon1
mercury_ssh="root@178.62.61.185"
mercury_units=(${baseunits[@]} ${gatewayunits[@]})

# hetzner-nuremberg
pollux_ssh="root@5.9.59.34"
pollux_units=(${baseunits[@]} ${storageunits[@]})

# hetzer-nuremberg
biham_ssh="root@188.40.114.11"
biham_units=(${baseunits[@]} ${storageunits[@]})

# hetzner-nuremberg
nihal_ssh="root@188.40.116.66"
nihal_units=(${baseunits[@]} ${storageunits[@]})

# digitalocean-nyc3
phobos_ssh="root@104.131.3.162"
phobos_units=(${baseunits[@]})

# digitalocean-fra1
deimos_ssh="root@46.101.230.158"
deimos_units=(${baseunits[@]})

# digitalocean-fra1
rigel_ssh="root@139.59.133.121"
rigel_units=(${baseunits[@]} ssl secrets/ssl)
