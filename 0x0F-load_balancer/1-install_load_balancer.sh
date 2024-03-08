#!/usr/bin/env bash
# Installs and sets up HAProxy

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install haproxy

sudo sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/haproxy
sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.original

# Deletes everything from the first empty line to the end of file
sudo sed -i '/^$/,$d' /etc/haproxy/haproxy.cfg

# Appends to the file using a here document
sudo tee -a /etc/haproxy/haproxy.cfg <<EOF
listen 749-lb-01
    bind *:80
    mode http
    balance roundrobin
    option httpclose
    option forwardfor
    server 749-web-02 54.146.94.67:80 check
    server 749-web-01 100.27.4.237:80 check
EOF

sudo service haproxy start
