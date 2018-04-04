{
    "privateKey": "$(var cjdns_private_key)",
    "admin": {
        "bind": "$(var cjdns_admin_address):$(var cjdns_admin_port)",
        "password": "$(var cjdns_admin_password)"
    },
    "interfaces": {
        "UDPInterface": [
        {
            "bind": "[$(var cjdns_udp6_address)]:$(var cjdns_udp6_port)",
            "connectTo": {
$(
for peer in $(lookup cjdns_udp6_peers 2>/dev/null); do
    printf '                "[%s]:%s": {\n' $(var 'cjdns_'$peer'_address') $(var 'cjdns_'$peer'_port')
    printf '                    "peerName": "%s",\n' $(var 'cjdns_'$peer'_peer_name')
    printf '                    "publicKey": "%s",\n' $(var 'cjdns_'$peer'_public_key')
    printf '                    "password": "%s"\n' $(var 'cjdns_'$peer'_password')
    printf '                },\n'
done
)
            }
        },
        {
            "bind": "$(var cjdns_udp4_address):$(var cjdns_udp4_port)",
            "connectTo": {
$(
for peer in $(lookup cjdns_udp4_peers); do
    printf '                "%s:%s": {\n' $(var 'cjdns_'$peer'_address') $(var 'cjdns_'$peer'_port')
    printf '                    "peerName": "%s",\n' $(var 'cjdns_'$peer'_peer_name')
    printf '                    "publicKey": "%s",\n' $(var 'cjdns_'$peer'_public_key')
    printf '                    "password": "%s"\n' $(var 'cjdns_'$peer'_password')
    printf '                },\n'
done
for h in ${provsn_hosts[@]}; do
    if [ "h$h" != "h$host" ]; then
        printf '                "%s:%s": {\n' $(host=$h var ipv4_address) $(host=$h var cjdns_udp4_port)
        printf '                    "peerName": "%s.i.ipfs.team",\n' $h
        printf '                    "publicKey": "%s",\n' $(host=$h var cjdns_public_key)
        printf '                    "password": "%s"\n' $(var cjdns_solarnet_password)
        printf '                },\n'
    fi
done
)
            }
        },
        ]
    },
    "authorizedPasswords": [
$(
for pwd in $(lookup cjdns_passwords); do
    printf '            {\n'
    printf '                "user": "%s",\n' $(var 'cjdns_'$pwd'_peer_name')
    printf '                "password": "%s"\n' $(var 'cjdns_'$pwd'_password')
    printf '            },\n'
done
)
    ],
    "router": {
        "interface": {
            "type": "TUNInterface",
            "tunDevice": "$(var cjdns_tun_interface)"
        }
    },
    // TODO check if the security section is still up-to-date (compare with cjdroute --genconf)
    "security": [
        { "setuser": "nobody", "keepNetAdmin": 1 },
        { "chroot": "/var/run/" },
        { "nofiles": 0 },
        { "noforks": 1 },
        { "seccomp": 1 },
        { "setupComplete": 1 }
    ],
    // "logging": {
    //     "logTo": "stdout"
    // }
}
