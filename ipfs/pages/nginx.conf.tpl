server {
    server_name protocol.ai ipn.io www.ipn.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    return 301 https://protocol.ai\$request_uri;
}

server {
    server_name *.i.ipfs.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/i.ipfs.io.crt;
    ssl_certificate_key /etc/nginx/certs/i.ipfs.io.key;
    ssl_dhparam /etc/nginx/certs/i.ipfs.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/i.ipfs.io.trustchain.crt;

    location / {
        proxy_set_header Host "";
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name orbit.chat;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/orbit.chat.crt;
    ssl_certificate_key /etc/nginx/certs/orbit.chat.key;
    ssl_dhparam /etc/nginx/certs/orbit.chat.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/orbit.chat.trustchain.crt;

    location / {
        proxy_set_header Host orbit.chat;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

upstream ws_bootstrap {
    server 127.0.0.1:8081;
}

server {
    server_name $(var pages_bootstrap_hostname).bootstrap.libp2p.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/bootstrap.libp2p.io.crt;
    ssl_certificate_key /etc/nginx/certs/bootstrap.libp2p.io.key;
    ssl_dhparam /etc/nginx/certs/bootstrap.libp2p.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/bootstrap.libp2p.io.trustchain.crt;

    location / {
        proxy_set_header Host \$host:80;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$http_connection;
        proxy_set_header Sec-WebSocket-Key \$http_sec_websocket_key;
        proxy_set_header Sec-WebSocket-Extensions \$http_sec_websocket_extensions;
        proxy_set_header Sec-WebSocket-Version \$http_sec_websocket_version;
        proxy_pass http://ws_bootstrap;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name ipld.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/ipld.io.crt;
    ssl_certificate_key /etc/nginx/certs/ipld.io.key;
    ssl_dhparam /etc/nginx/certs/ipld.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/ipld.io.trustchain.crt;

    location / {
        proxy_set_header Host ipld.io;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name libp2p.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/libp2p.io.crt;
    ssl_certificate_key /etc/nginx/certs/libp2p.io.key;
    ssl_dhparam /etc/nginx/certs/libp2p.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/libp2p.io.trustchain.crt;

    location / {
        proxy_set_header Host libp2p.io;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name multiformats.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/multiformats.io.crt;
    ssl_certificate_key /etc/nginx/certs/multiformats.io.key;
    ssl_dhparam /etc/nginx/certs/multiformats.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/multiformats.io.trustchain.crt;

    location / {
        proxy_set_header Host multiformats.io;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name zcash.dag.ipfs.io;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/zcash.dag.ipfs.io.crt;
    ssl_certificate_key /etc/nginx/certs/zcash.dag.ipfs.io.key;
    ssl_dhparam /etc/nginx/certs/zcash.dag.ipfs.io.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/zcash.dag.ipfs.io.trustchain.crt;

    location / {
        proxy_set_header Host zcash.dag.ipfs.io;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name protocol.ai;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/protocol.ai.crt;
    ssl_certificate_key /etc/nginx/certs/protocol.ai.key;
    ssl_dhparam /etc/nginx/certs/protocol.ai.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/protocol.ai.trustchain.crt;

    location / {
        proxy_set_header Host protocol.ai;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 80;
    listen [::]:80;
    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/wikipedia-on-ipfs.org.trustchain.crt;

    return 301 https://ipfs.io/blog/24-uncensorable-wikipedia/;
}

server {
    server_name en.wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/en.wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/en.wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/en.wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/en.wikipedia-on-ipfs.org.trustchain.crt;

    location / {
        proxy_set_header Host en.wikipedia-on-ipfs.org;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name tr.wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/tr.wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/tr.wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/tr.wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/tr.wikipedia-on-ipfs.org.trustchain.crt;

    location / {
        proxy_set_header Host tr.wikipedia-on-ipfs.org;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name simple.wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/simple.wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/simple.wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/simple.wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/simple.wikipedia-on-ipfs.org.trustchain.crt;

    location / {
        proxy_set_header Host simple.wikipedia-on-ipfs.org;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name ar.wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/ar.wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/ar.wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/ar.wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/ar.wikipedia-on-ipfs.org.trustchain.crt;

    location / {
        proxy_set_header Host ar.wikipedia-on-ipfs.org;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}

server {
    server_name ku.wikipedia-on-ipfs.org;
    access_log /var/log/nginx/access.log mtail;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/nginx/certs/ku.wikipedia-on-ipfs.org.crt;
    ssl_certificate_key /etc/nginx/certs/ku.wikipedia-on-ipfs.org.key;
    ssl_dhparam /etc/nginx/certs/ku.wikipedia-on-ipfs.org.dhparam.pem;
    ssl_trusted_certificate /etc/nginx/certs/ku.wikipedia-on-ipfs.org.trustchain.crt;

    location / {
        proxy_set_header Host ku.wikipedia-on-ipfs.org;
        # The gateway upstream is defined in the ipfs/gateway unit.
        proxy_pass http://gateway;
        proxy_pass_header Server;
        proxy_read_timeout 60s;
    }
}
