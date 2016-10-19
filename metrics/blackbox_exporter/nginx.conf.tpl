server {
    server_name blackbox_exporter.local;
    access_log /var/log/nginx/access.log mtail;
    listen [$(var cjdns_ipv6)]:9115;

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
        proxy_pass http://127.0.0.1:9115;
        proxy_set_header Host \$host;
    }
}
