#!/bin/bash
mkdir -p /etc/letsencrypt
mkdir -p /var/lib/letsencrypt

docker run -p 80:80 --rm --name certbot \
    -v '/etc/letsencrypt:/etc/letsencrypt' \
    -v '/var/lib/letsencrypt:/var/lib/letsencrypt' \
    certbot/certbot renew
