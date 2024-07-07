#!/usr/bin/env bash
CONFIG_PATH=/data/options.json

PORT=$(jq --raw-output '.port' $CONFIG_PATH)
HA_TOKEN=$(jq --raw-output '.ha_token' $CONFIG_PATH)
LIGHTS=$(jq --compact-output '.lights' $CONFIG_PATH)

export HA_BRIDGE_PORT=$PORT
export HA_TOKEN=$HA_TOKEN
export CONFIG_FILE=/usr/src/app/config.js

echo "module.exports = { lights: $LIGHTS };" > /usr/src/app/config.js

node index.js
