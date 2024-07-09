#!/usr/bin/env bash
CONFIG_PATH=/data/options.json

PORT=$(jq --raw-output '.port' $CONFIG_PATH)
HA_TOKEN=$(jq --raw-output '.ha_token' $CONFIG_PATH)
LIGHTS=$(jq --compact-output '.lights' $CONFIG_PATH)

export HA_BRIDGE_PORT=$PORT
export HA_TOKEN=$HA_TOKEN
export CONFIG_FILE=/usr/src/app/config.js

if [ -z "$LIGHTS" ]; then
  echo "module.exports = { lights: [] };" > /usr/src/app/config.js
else
  echo "module.exports = { lights: $LIGHTS };" > /usr/src/app/config.js
fi

# Clear previous logs
> /config/hyperion_ha_bridge.log

node index.js
