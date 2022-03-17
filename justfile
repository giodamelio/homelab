@_list:
  just --list

proxy-reload-config:
  docker exec proxy caddy reload -config /etc/caddy/Caddyfile