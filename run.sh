#!/usr/bin/env bash
CONFIG_PATH=/data/options.json

PORT=$(jq --raw-output '.port' $CONFIG_PATH)
HA_TOKEN=$(jq --raw-output '.ha_token' $CONFIG_PATH)
LIGHTS=$(jq --compact-output '.lights' $CONFIG_PATH)

export HA_BRIDGE_PORT=$PORT
export HA_TOKEN=$HA_TOKEN
export HA_LIGHTS=$LIGHTS

if [ -z "$PORT" ] || [ -z "$HA_TOKEN" ] || [ -z "$LIGHTS" ]; then
  echo "Error: Missing required configuration options" >&2
  exit 1
fi

node index.js
