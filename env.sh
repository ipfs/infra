#!/usr/bin/env bash

provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury pollux biham phobos deimos)
# provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal)
# provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury)
provsn_groups=()

all_ssh_options="-o ConnectTimeout=30"
all_omit_build=(secrets)

baseunits=(secrets base docker nginx mtail)
gatewayunits=(ipfs ipfs/gateway ssl)
storageunits=(ipfs)

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

# cjdns ipv6 addresses of community members
# allows access to internal http endpoints on each host's cjdns ipv6 address.
all_vpn_allowlist=()
# lgierth
all_vpn_allowlist+=("fc3d:7777:a6a4:fcdb:f218:5856:5de:eb1a")
all_vpn_allowlist+=("fc0c:f70f:320e:21c2:bfe8:b9ff:fcbf:43e9")
# cryptix
all_vpn_allowlist+=("fc58:6e49:3820:8c65:a37b:a250:6e03:ab9")
all_vpn_allowlist+=("fce4:cb57:6b99:1f23:10d:6902:f947:2218")
# whyrusleeping
all_vpn_allowlist+=("fc72:84:1b05:1e14:ef35:e055:651b:8465")
# dignifiedquire
all_vpn_allowlist+=("fcd3:58f5:a447:74a2:a0fa:ce6b:5e60:1d98")
# kubuxu
all_vpn_allowlist+=("fc00:5555:b994:a83e:ea79:eabc:61a5:8af8")
all_vpn_allowlist+=("fc68:4444:9c8d:7936:4e9d:1470:b2cc:677f")
