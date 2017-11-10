#!/usr/bin/env bash

# Names of the target hosts.
# These are just names, nothing is being inferred from them.
# Host-specific settings can be set like this: <host>_<setting>
provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury scrappy chappy pollux biham nihal auva banana deimos jenkins pages)

# Provsn appends these to every SSH invocation.
all_ssh_options="-o ConnectTimeout=30 -o UserKnownHostsFile=$provsn_root/known_hosts -o StrictHostKeyChecking=yes"

# These unit shorthands are a workaround for the current lack of host-groups.
# TODO: We'll eventually be able to specify e.g. the following:
#   provsn_groups=(gateway storage)
#   gateway_hosts=(pluto neptune ...)
#   gateway_units=(ipfs ipfs/gateway ssl)
# We can then omit the repeated <host>_units definitions.
baseunits=(secrets base base/golang cjdns docker nginx)
baseunits+=(mtail metrics/node_exporter metrics/blackbox_exporter)
gatewayunits=(ipfs ipfs/gateway ipfs/pages ssl)
storageunits=(ipfs)
bootstrapunits=(ipfs)
metricsunits=(metrics/grafana metrics/prometheus)

# Units listed in `omit_build` will not be copied into each host's .build dir.
# This Avoids copying secrets to hosts that shouldn't have them.
# If a unit e.g. makes use of a certain secret, it needs to somehow process
# it within its build script. See the ipfs and ssl units for examples.
all_omit_build=(secrets)

# digitalocean-sfo1
pluto_ssh="root@pluto.i.ipfs.team"
pluto_ipv4_address="104.236.179.241"
pluto_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sfo1
neptune_ssh="root@neptune.i.ipfs.team"
neptune_ipv4_address="104.236.176.52"
neptune_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-nyc2
uranus_ssh="root@uranus.i.ipfs.team"
uranus_ipv4_address="162.243.248.213"
uranus_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sgp1
saturn_ssh="root@saturn.i.ipfs.team"
saturn_ipv4_address="128.199.219.111"
saturn_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-sfo1
jupiter_ssh="root@jupiter.i.ipfs.team"
jupiter_ipv4_address="104.236.151.122"
jupiter_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-nyc3
venus_ssh="root@venus.i.ipfs.team"
venus_ipv4_address="104.236.76.40"
venus_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-ams2
earth_ssh="root@earth.i.ipfs.team"
earth_ipv4_address="178.62.158.247"
earth_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-lon1
mercury_ssh="root@mercury.i.ipfs.team"
mercury_ipv4_address="178.62.61.185"
mercury_units=(${baseunits[@]} ${gatewayunits[@]})

# ovh
scrappy_ssh="root@scrappy.i.ipfs.team"
scrappy_ipv4_address="217.182.195.23"
scrappy_units=(${baseunits[@]} ${gatewayunits[@]})

# ovh
chappy_ssh="root@chappy.i.ipfs.team"
chappy_ipv4_address="147.135.130.181"
chappy_units=(${baseunits[@]} ${gatewayunits[@]})

# hetzner-nuremberg
pollux_ssh="root@pollux.i.ipfs.team"
pollux_ipv4_address="5.9.59.34"
pollux_units=(${baseunits[@]} ${storageunits[@]})

# hetzer-nuremberg
# This one is used for storage but technically a gateway,
# so that it's easier to run metrics tests against it
# without being affected by varying load on the actual gateways.
biham_ssh="root@biham.i.ipfs.team"
biham_ipv4_address="188.40.114.11"
biham_units=(${baseunits[@]} ${gatewayunits[@]})

# hetzner-nuremberg
nihal_ssh="root@nihal.i.ipfs.team"
nihal_ipv4_address="188.40.116.66"
nihal_units=(${baseunits[@]} ${storageunits[@]})

# hetzner-nuremberg
auva_ssh="root@auva.i.ipfs.team"
auva_ipv4_address="144.76.60.46"
auva_units=(${baseunits[@]} ${storageunits[@]})

# hetzner
banana_ssh="root@banana.i.ipfs.team"
banana_ipv4_address="78.46.136.129"
banana_units=(${baseunits[@]} ${metricsunits[@]})

# digitalocean-fra1
deimos_ssh="root@deimos.i.ipfs.team"
deimos_ipv4_address="46.101.230.158"
deimos_units=(${baseunits[@]})

# digitalocean-nyc3
jenkins_ssh="root@jenkins.i.ipfs.team"
jenkins_ipv4_address="104.236.203.34"
jenkins_units=(${baseunits[@]} ci/jenkins ssl)

# digitalocean-ams3
pages_ssh="root@pages.i.ipfs.team"
pages_ipv4_address="128.199.43.144"
pages_units=(secrets base base/golang cjdns docker ipfs)

# Cjdns IPv6 addresses allowed to access internal HTTP endpoints on each host.
# These are e.g. the IPFS HTTP API on tcp/5001, or various metrics collectors.
# See the base unit for each hosts cjdns IPv6 address.
all_vpn_allowlist=()
# lgierth
all_vpn_allowlist+=("fc3d:7777:a6a4:fcdb:f218:5856:5de:eb1a")
all_vpn_allowlist+=("fcd0:ad3d:c5e4:afa8:56ed:cce2:57a3:39ba")
# whyrusleeping
all_vpn_allowlist+=("fceb:9e0b:da69:391f:ff35:22b3:2d04:3214")
# dignifiedquire
all_vpn_allowlist+=("fc04:f62e:6fcf:9c82:b020:69ce:c2e6:34b2")
# kubuxu
all_vpn_allowlist+=("fc00:5555:b994:a83e:ea79:eabc:61a5:8af8")
all_vpn_allowlist+=("fc68:4444:9c8d:7936:4e9d:1470:b2cc:677f")
# victorbjelkholm
all_vpn_allowlist+=("fc7e:76f4:cfae:c1f3:e754:6b1d:bcd6:6281")
# teamcity
all_vpn_allowlist+=("fcbf:94cf:55d3:da57:a159:86cc:3b5d:70e9")
# jbenet
all_vpn_allowlist+=("fc32:6e9e:9095:bbfb:b7e1:059c:9f7b:ad48")
# stebalien
all_vpn_allowlist+=("fc6f:868d:1ca5:e639:2e60:e1d5:db99:c885")
