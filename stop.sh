#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

echo "Stopping nginx-proxy-manager..."
docker compose -f "$SCRIPT_DIR/nginx-proxy-manager/docker-compose.yml" --env-file "$ENV_FILE" down

echo "Stopping n8n..."
docker compose -f "$SCRIPT_DIR/n8n/docker-compose.yml" --env-file "$ENV_FILE" down

echo "Stopping open-webui..."
docker compose -f "$SCRIPT_DIR/open-webui/docker-compose.yml" --env-file "$ENV_FILE" down

echo "Stopping postgres..."
docker compose -f "$SCRIPT_DIR/postgres/docker-compose.yml" --env-file "$ENV_FILE" down

echo "All services stopped."
