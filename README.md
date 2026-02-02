# OpenClaw Portable Docker Setup

A completely portable, self-contained Docker deployment of OpenClaw AI assistant. This setup prioritizes simplicity and complete data persistence.

## Quick Start

```bash
cd ~/openclaw-home
docker compose up -d
```

## Common Operations

### View Logs
```bash
docker compose logs -f
```

### Stop
```bash
docker compose stop
```

### Start
```bash
docker compose start
```

### Restart
```bash
docker compose restart
```

### Check Status
```bash
docker compose ps
```

### Run Commands Inside Container
```bash
docker compose exec openclaw openclaw config --section model
```

## Backup & Restore

### Create Snapshot
```bash
docker commit openclaw openclaw:snapshot-$(date +%Y%m%d-%H%M%S)
```

### Export Snapshot
```bash
docker save openclaw:snapshot-20260201-192105 | gzip > backup.tar.gz
```

### Load on New Machine
```bash
docker load < backup.tar.gz
# Update image name in docker compose.yml
docker compose up -d
```

## Access Points

- Gateway: http://YOUR_SERVER_IP:18789
- Browser Control: http://YOUR_SERVER_IP:18791

## Data Storage

All data persists in Docker volume `openclaw-complete`:
- Config: `/root/.openclaw/`
- Workspace: `/root/.openclaw/workspace/`
- Sessions, personality, everything

## Architecture

- Base: Ubuntu 24.04 LTS
- Runtime: Node.js 22
- OpenClaw: npm global install
- Persistence: Full filesystem in named volume

Simple. Complete. Portable.
