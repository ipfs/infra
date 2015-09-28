#!/usr/bin/env bash

# Builds a cjdroute.conf snippet for peering with all nodes in secrets.yml
#
# Usage:
#   ./peering.sh

# Primitive YAML parser for Bash, https://stackoverflow.com/a/21189044/2068670
# By Stefan Farestam, updated for basic YAML array support
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)-$s\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)-$s\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(parse_yaml roles/cjdns/vars/main.yml)
eval $(parse_yaml secrets_plaintext/secrets.yml)

hosts=$(ansible all --list-hosts)
port=$(echo $cjdns_udp_interfaces_bind | cut -d':' -f2)
password=$cjdns_authorized_passwords_password

for host in $hosts; do
  eval "pubkey=\$cjdns_identities_$host""_public_key"
  ipAddr=$(ansible $host -m debug -a 'var=ansible_ssh_host' -o | cut -d'>' -f 3 | jq -r '.var.ansible_ssh_host')

  [ -z "$pubkey" ] || cat << JSON
    "$ipAddr:$port": {
        "peerName": "$host.i.ipfs.io",
        "publicKey": "$pubkey",
        "password": "$password"
    },
JSON
done
