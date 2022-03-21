@_list:
  just --list

proxy-reload-config:
  docker exec proxy caddy reload -config /etc/caddy/Caddyfile

list-traefik-https-certs:
  sudo cat ~/homelab/data/traefik/acme/acme.json | jq '.le.Certificates[].domain'
