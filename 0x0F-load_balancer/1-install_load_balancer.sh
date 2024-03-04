#!/usr/bin/env bash
# Installs and sets up HAProxy

# Install HAProxy repository
apt-get install -y software-properties-common
add-apt-repository -y ppa:vbernat/haproxy-1.8

# Update package repositories
apt-get -y update

# Install HAProxy version 1.8
apt-get install -y haproxy=1.8.*

# Enable HAProxy service
echo "ENABLED=1" > /etc/default/haproxy

# Configure HAProxy
cat <<EOF >> /etc/haproxy/haproxy.cfg
listen load_balancer
    bind *:80
    mode http
    balance roundrobin
    option httpclose
    option forwardfor
    server web1 44.200.83.158:80 check
    server web2 3.237.16.226:80 check
EOF

# Start HAProxy service
service haproxy start
