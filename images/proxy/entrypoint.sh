#!/bin/sh

# Create the aws credentials file with values from the environment
mkdir -p /root/.aws/
printf "[default]\n" >> /root/.aws/credentials
printf "aws_access_key_id = %s\n" $AWS_ACCESS_KEY_ID >> /root/.aws/credentials
printf "aws_secret_access_key = %s\n" $AWS_SECRET_ACCESS_KEY >> /root/.aws/credentials

# Run the Caddy server
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile