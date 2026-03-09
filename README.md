# Homelab

A centralized directory for managing personal development services using Docker and Docker Compose.

## Overview

Each service is containerized and managed via Docker Compose. We use a **shared PostgreSQL instance** and a **dedicated Docker network** (`homelab-net`) for inter-service communication. Routing is handled by a plain **nginx** reverse proxy with path-based access.

## Services

| Service | Description | Access |
|---|---|---|
| **nginx** | Reverse proxy | Port 80/443 |
| **n8n** | Workflow automation | `http://HOST/n8n/` |
| **Open WebUI** | LLM web interface | `http://HOST/open-webui/` |
| **PostgreSQL** | Shared database | Internal only |

## Network Architecture

```text
       Internet
          │
          ▼
    ┌───────────┐
    │ Port 80/443 │
    └─────┬─────┘
          │
    ┌─────▼─────┐
    │   nginx   │
    └┬─────────┬┘
     │ /n8n/   │ /open-webui/   [homelab-net]
     ▼         ▼
  ┌─────┐  ┌──────────┐  ┌──────────┐
  │ n8n │  │ Open     │  │ Shared   │
  │     │  │ WebUI    │  │ Postgres │
  └─────┘  └──────────┘  └──────────┘
```

## Directory Structure

```text
/opt/docker/homelab/
├── README.md
├── start.sh          # Start all services
├── stop.sh           # Stop all services
├── .env              # Environment variables
├── nginx/
│   ├── docker-compose.yml
│   └── conf.d/
│       └── default.conf  # Routing config
├── n8n/
│   └── docker-compose.yml
├── open-webui/
│   └── docker-compose.yml
└── postgres/
    └── docker-compose.yml
```

## Setup Instructions

### 1. Initial setup (first time only)

Create the shared Docker network:
```bash
docker network create homelab-net
```

Create databases in PostgreSQL (after postgres is running):
```bash
docker exec postgres psql -U homelab_user -d postgres -c 'CREATE DATABASE n8n;'
docker exec postgres psql -U homelab_user -d postgres -c 'CREATE DATABASE "open-webui";'
```

Fix n8n data directory permissions:
```bash
sudo chown -R 1000:1000 /opt/docker/homelab/n8n/data
```

### 2. Start / Stop all services

```bash
chmod +x start.sh stop.sh  # first time only
./start.sh
./stop.sh
```

## Routing

nginx routes requests by path prefix, stripping the prefix before forwarding:

| URL | Forwards to |
|---|---|
| `http://HOST/n8n/` | `http://n8n:5678` |
| `http://HOST/open-webui/` | `http://open-webui:8080` |

To add a new service, edit `nginx/conf.d/default.conf`.
