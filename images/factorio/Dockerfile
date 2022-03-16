# Just need this to get the tailscale binaries
FROM docker.io/tailscale/tailscale:v1.22 AS tailscale

# Build the actual NGINX image with Tailscale preinstalled
FROM docker.io/ubuntu:focal

WORKDIR /srv

ENV FACTORIO_VERSION="1.1.53"
ENV FACTORIO_PORT="34197"
ENV FACTORIO_RCON_PORT="27015"

ENV HIVEMIND_VERSION="v1.1.0"

# Expose the volumes
VOLUME /srv/mods
VOLUME /srv/saves
VOLUME /srv/server_configs

# Copy tailscale binaries
COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscale
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscaled

# Install some curl and gzip
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qq curl gzip xz-utils

# Install Factorio
RUN curl -L https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64 -o server.tar.xz \
  && tar xfv server.tar.xz

# Install hivemind to run multiple programs
RUN curl -Lo hivemind.gz https://github.com/DarthSim/hivemind/releases/download/${HIVEMIND_VERSION}/hivemind-${HIVEMIND_VERSION}-linux-amd64.gz \
    && gunzip hivemind.gz \
    && chmod +x hivemind \
    && mv hivemind /usr/local/bin/

# Add the procfile to run the multiple programs
COPY Procfile /srv/Procfile
COPY factorio.sh /srv/factorio.sh

ENTRYPOINT hivemind /srv/Procfile