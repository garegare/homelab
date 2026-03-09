# Homelab

A centralized directory for managing personal development services using Docker and Docker Compose.

## Overview

Each service is containerized and managed via Docker Compose. We use a **shared PostgreSQL instance** and a **dedicated Docker network** (`homelab-net`) to allow inter-service communication.

## Services

- **Nginx Proxy Manager**: Reverse proxy and SSL certificate management.
- **Open WebUI**: Web interface for Large Language Models (LLMs).
- **n8n**: Workflow automation tool (Connected to shared Postgres).
- **PostgreSQL**: Shared database for all services.

## Network Architecture

```text
       Internet
          │
          ▼
    ┌───────────┐
    │ Port 80/443 │
    └─────┬─────┘
          │
  ┌───────▼───────┐
  │ Nginx Proxy   │
  │    Manager    │
  └┬─────────────┬┘
   │             │ [homelab-net]
   ▼             ▼
┌────────┐    ┌────────┐    ┌──────────┐
│  n8n   │    │  Open  │    │ Shared   │
│        │────▶  WebUI ◄────┤ Postgres │
└────────┘    └────────┘    └──────────┘
```

## Directory Structure

```text
/opt/docker/homelab/
├── README.md
├── nginx-proxy-manager/
├── open-webui/
├── n8n/
└── postgres/        # Shared Database
```

## Setup Instructions

1. Create the shared network:
   ```bash
   docker network create homelab-net
   ```
2. Start the database first:
   ```bash
   cd postgres && docker compose up -d
   ```
3. Start other services:
   ```bash
   cd ../n8n && docker compose up -d
   ```
