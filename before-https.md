Things to do to enable https

- Expose caddy proxy container port
- Forward host port 443 to container via firewall
- Add firewall command to Justfile
- Configure Caddy to use Route53 LE DNS-01 Challenge