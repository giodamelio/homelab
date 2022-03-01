#!/bin/bash

caddy fmt -overwrite Caddyfile
podman-compose exec proxy caddy reload -config /etc/caddy/Caddyfile