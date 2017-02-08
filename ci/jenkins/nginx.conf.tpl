server {
    server_name ci.ipfs.team;
    access_log /var/log/nginx/access.log mtail;
    listen 80;
    listen [::]:80;

    listen 443 default_server ssl;
    listen [::]:443 default_server ssl;
    ssl_certificate /etc/nginx/certs/ci.ipfs.team.crt;
    ssl_certificate_key /etc/nginx/certs/ci.ipfs.team.key;
    ssl_dhparam /etc/nginx/certs/ci.ipfs.team.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/ci.ipfs.team.trustchain.crt;

    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host \$host;
    }

    location /prometheus {
        return 403;
    }
}

server {
    access_log /var/log/nginx/access.log mtail;
    listen [$(var cjdns_ipv6)]:8090;

    location / {
        return 403;
    }

    location /prometheus {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host \$host;

$(
for h in ${provsn_hosts[@]}; do
    printf '        allow %s; # %s.v.ipfs.team\n' $(host=$h var cjdns_ipv6) $h
done
for addr in $(var vpn_allowlist); do
    printf '        allow %s; # vpn allowlist\n' $addr
done
)
        allow 127.0.0.1;
        allow ::1;
        deny all;
    }
}

