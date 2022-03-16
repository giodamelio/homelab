#!/bin/sh

./factorio/bin/x64/factorio \
  --start-server /srv/saves/world.zip \
  --server-settings /srv/server_configs/server-settings.json
  --rcon-port ${FACTORIO_RCON_PORT} \
  --rcon-password $(cat /srv/server_configs/rcon_password)