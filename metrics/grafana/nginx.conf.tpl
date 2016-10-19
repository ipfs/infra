server {
    listen [$(var cjdns_ipv6)]:80;
    server_name metrics.ipfs.team;

# TODO this general access control should be its own nginx file, just like ssl
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

    # prometheus
    location /prometheus {
        proxy_pass http://127.0.0.1:9090;
        proxy_set_header Host \$host;
    }

    # grafana
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
    }

    access_log /var/log/nginx/metrics.access.log mtail;
    error_log /var/log/nginx/metrics.error.log;
}
