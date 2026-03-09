#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Create shared network if it doesn't exist
if ! docker network inspect homelab-net &>/dev/null; then
  echo "Creating homelab-net network..."
  docker network create homelab-net
fi

echo "Starting postgres..."
docker compose -f "$SCRIPT_DIR/postgres/docker-compose.yml" --env-file "$ENV_FILE" up -d

echo "Starting n8n..."
docker compose -f "$SCRIPT_DIR/n8n/docker-compose.yml" --env-file "$ENV_FILE" up -d

echo "Starting open-webui..."
docker compose -f "$SCRIPT_DIR/open-webui/docker-compose.yml" --env-file "$ENV_FILE" up -d

echo "Starting nginx..."
docker compose -f "$SCRIPT_DIR/nginx/docker-compose.yml" --env-file "$ENV_FILE" up -d

echo "All services started."
