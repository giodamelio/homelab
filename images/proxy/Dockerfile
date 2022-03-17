# Build a version of Caddy with the Route53 DNS module included
FROM docker.io/caddy:2-builder-alpine AS builder

RUN xcaddy build \
  --with github.com/caddy-dns/route53 \
  --with github.com/greenpau/caddy-security \
  --with github.com/greenpau/caddy-trace

# Normal docker image
FROM docker.io/caddy:2-alpine

# Get the custom caddy from the builder
COPY --from=builder /usr/bin/caddy /usr/bin/caddy