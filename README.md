# OpenClaw Docker Setup

Portable Docker deployment with persistent state.

## Architecture

```
┌─────────────────────────────────────┐
│  Container (openclaw)               │
│  - Ubuntu 24.04 + Node.js 22        │
│  - OpenClaw runtime                 │
│                                     │
│  /root/.openclaw ──────────────┐    │
└────────────────────────────────│────┘
                                 │ volume mount
                    ┌────────────▼────────────┐
                    │  Volume: openclaw-data  │
                    │  - Config, Workspace    │
                    │  - Sessions, Memory     │
                    └─────────────────────────┘
```

State lives in the volume, not the container.

## Quick Start

### First Time Setup

```bash
# Create the data volume
docker volume create openclaw-data

# Run the interactive onboarding wizard
docker compose run --rm onboard

# Start the gateway
docker compose up -d
```

### Subsequent Starts

```bash
docker compose up -d
```

Builds image from Dockerfile automatically on first run.

## Updating OpenClaw

Rebuild to pull latest:

```bash
docker compose up -d --build
```

## Backup & Restore

```bash
# Create timestamped backup
docker compose run --rm backup

# Restore
docker compose run --rm restore bosun-YYYYMMDD-HHMMSS.tar.gz
docker compose restart openclaw
```

Backups stored in `./backups/`

## Move to Another Machine

```bash
# 1. Backup
docker compose run --rm backup

# 2. Copy everything
scp -r openclaw-home/ newserver:~/

# 3. On new machine
cd ~/openclaw-home
docker volume create openclaw-data
docker compose run --rm restore bosun-YYYYMMDD-HHMMSS.tar.gz
docker compose up -d
```

## Access

- Gateway: `http://<ip>:18789`
- Browser: `http://<ip>:18791`
