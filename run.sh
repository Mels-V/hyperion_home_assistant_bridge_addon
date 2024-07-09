#!/usr/bin/env bash
CONFIG_PATH=/data/options.json

PORT=$(jq --raw-output '.port' $CONFIG_PATH)
LIGHTS=$(jq --compact-output '.lights' $CONFIG_PATH)
MAX_BRIGHTNESS=$(jq --raw-output '.max_brightness' $CONFIG_PATH)

export HA_BRIDGE_PORT=$PORT
export HA_LIGHTS=$LIGHTS
export HA_MAX_BRIGHTNESS=$MAX_BRIGHTNESS
export SUPERVISOR_TOKEN=$SUPERVISOR_TOKEN

if [ -z "$PORT" ] || [ -z "$SUPERVISOR_TOKEN" ] || [ -z "$LIGHTS" ] || [ -z "$MAX_BRIGHTNESS" ]; then
  echo "Error: Missing required configuration options" >&2
  exit 1
fi

node index.js
