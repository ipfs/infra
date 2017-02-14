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
