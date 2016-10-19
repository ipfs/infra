server {
    server_name node_exporter.local;
    access_log /var/log/nginx/access.log mtail;
    listen [$(var cjdns_ipv6)]:9100;

$(
for h in ${provsn_hosts[@]}; do
    printf '    allow %s; # %s.v.ipfs.team\n' $(host=$h var cjdns_ipv6) $h
done
for addr in $(var vpn_allowlist); do
    printf '    allow %s; # vpn allowlist\n' $addr
done
)
    allow 127.0.0.1;
    allow ::1;
    deny all;

    location / {
        proxy_pass http://127.0.0.1:9100;
        proxy_set_header Host \$host;
    }
}

# TODO this needs to move to the mtail unit
server {
    server_name mtail.local;
    access_log /var/log/nginx/access.log mtail;
    listen [$(var cjdns_ipv6)]:3903;

$(
for h in ${provsn_hosts[@]}; do
    printf '    allow %s; # %s.v.ipfs.team\n' $(host=$h var cjdns_ipv6) $h
done
for addr in $(var vpn_allowlist); do
    printf '    allow %s; # vpn allowlist\n' $addr
done
)
    allow 127.0.0.1;
    allow ::1;
    deny all;

    location / {
        proxy_pass http://127.0.0.1:3903;
        proxy_set_header Host \$host;
    }
}
