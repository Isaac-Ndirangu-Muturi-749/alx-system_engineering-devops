#!/usr/bin/env bash

# Update package list and install snapd
sudo apt -y update
sudo apt -y install snapd

# Install Certbot via snap
sudo apt-get -y remove certbot
sudo apt-get -y install certbot

# Stop HAProxy service temporarily
sudo service haproxy stop

# Obtain SSL certificate using Certbot standalone mode
sudo certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d www.inm-749.com

# List the contents of the directory where Let's Encrypt stores the certificates for the domain www.inm-749.tech
sudo ls /etc/letsencrypt/live/www.inm-749.tech

# Create a directory to store the HAProxy certificates if it doesn't exist already
sudo mkdir -p /etc/haproxy/certs

# Concatenate fullchain.pem and privkey.pem into a single certificate file
DOMAIN='www.inm-749.com' sudo -E bash -c '
    cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
    /etc/letsencrypt/live/$DOMAIN/privkey.pem \
    > /etc/haproxy/certs/$DOMAIN.pem
'

# Restrict permissions for certificate files
sudo chmod -R go-rwx /etc/haproxy/certs

# Configure HAProxy
sudo tee /etc/haproxy/haproxy.cfg > /dev/null <<EOF
# Global settings
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

# Default SSL material locations
ca-base /etc/ssl/certs
crt-base /etc/ssl/private

# Default ciphers to use on SSL-enabled listening sockets
ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
ssl-default-bind-options no-sslv3

# Default server configuration
defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

# HTTP frontend for HTTP requests
frontend www-http
    bind *:80
    mode http
    http-request redirect scheme https code 301 if !{ ssl_fc }
    http-request set-header X-Forwarded-Proto http
    default_backend www-backend

# HTTPS frontend for SSL/TLS encrypted requests
frontend www-https
    bind *:443 ssl crt /etc/haproxy/certs/www.inm-749.tech.pem
    http-request set-header X-Forwarded-Proto https
    default_backend www-backend

# Backend for serving HTTP requests
backend www-backend
    balance roundrobin
    server 339243-web-01 35.153.193.23:80 check
    server 339243-web-02 54.146.94.67:80 check

EOF

# Start HAProxy service
sudo service haproxy start

# Verify HAProxy configuration
curl -sI localhost
