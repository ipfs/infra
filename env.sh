#!/usr/bin/env bash

# Names of the target hosts.
# These are just names, nothing is being inferred from them.
# Host-specific settings can be set like this: <host>_<setting>
provsn_hosts=(pluto neptune uranus saturn jupiter venus earth mercury pollux biham nihal banana deimos blueberry strawberry jenkins)

# Provsn appends these to every SSH invocation.
all_ssh_options="-o ConnectTimeout=30"

# These unit shorthands are a workaround for the current lack of host-groups.
# TODO: We'll eventually be able to specify e.g. the following:
#   provsn_groups=(gateway storage)
#   gateway_hosts=(pluto neptune ...)
#   gateway_units=(ipfs ipfs/gateway ssl)
# We can then omit the repeated <host>_units definitions.
baseunits=(secrets base base/golang cjdns docker nginx)
baseunits+=(mtail metrics/node_exporter metrics/blackbox_exporter)
gatewayunits=(ipfs ipfs/gateway ssl)
storageunits=(ipfs)
bootstrapunits=(ipfs)
metricsunits=(metrics/grafana metrics/prometheus)

# Units listed in `omit_build` will not be copied into each host's .build dir.
# This Avoids copying secrets to hosts that shouldn't have them.
# If a unit e.g. makes use of a certain secret, it needs to somehow process
# it within its build script. See the ipfs and ssl units for examples.
all_omit_build=(secrets)

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

# digitalocean-nyc3
venus_ssh="root@104.236.76.40"
venus_units=(${baseunits[@]} ${gatewayunits[@]})

# digitalocean-ams2
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

# hetzner
banana_ssh="root@78.46.136.129"
banana_units=(${baseunits[@]} ${metricsunits[@]})

# digitalocean-fra1
deimos_ssh="root@46.101.230.158"
deimos_units=(${baseunits[@]})

# digitalocean-ams3
blueberry_ssh="root@178.62.215.134"
blueberry_units=(${baseunits[@]} ${bootstrapunits[@]})

# digitalocean-nyc3
strawberry_ssh="root@159.203.166.189"
strawberry_units=(${baseunits[@]} ${bootstrapunits[@]})

jenkins_ssh="root@104.236.203.34"
jenkins_units=(${baseunits[@]})

# Cjdns IPv6 addresses allowed to access internal HTTP endpoints on each host.
# These are e.g. the IPFS HTTP API on tcp/5001, or various metrics collectors.
# See the base unit for each hosts cjdns IPv6 address.
all_vpn_allowlist=()
# lgierth
all_vpn_allowlist+=("fc3d:7777:a6a4:fcdb:f218:5856:5de:eb1a")
all_vpn_allowlist+=("fc0c:f70f:320e:21c2:bfe8:b9ff:fcbf:43e9")
all_vpn_allowlist+=("fc0d:66d:1e17:d13d:a1e7:1f41:87f0:5e63")
# whyrusleeping
all_vpn_allowlist+=("fcd2:11ef:3362:a108:faa5:1d61:58a4:1292")
# dignifiedquire
all_vpn_allowlist+=("fc04:f62e:6fcf:9c82:b020:69ce:c2e6:34b2")
# kubuxu
all_vpn_allowlist+=("fc00:5555:b994:a83e:ea79:eabc:61a5:8af8")
all_vpn_allowlist+=("fc68:4444:9c8d:7936:4e9d:1470:b2cc:677f")
# victorbjelkholm
all_vpn_allowlist+=("fc7e:76f4:cfae:c1f3:e754:6b1d:bcd6:6281")
# benhylau
all_vpn_allowlist+=("fcaf:c9e1:bfff:73a3:c08c:51aa:3711:2ccc")
# teamcity
all_vpn_allowlist+=("fcbf:94cf:55d3:da57:a159:86cc:3b5d:70e9")
