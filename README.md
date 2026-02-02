# OpenClaw Portable Docker Setup

A completely portable, self-contained Docker deployment of OpenClaw AI assistant.

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

### Restart (keeps all data)
```bash
docker compose restart
```

### Stop
```bash
docker compose stop
```

### Start
```bash
docker compose start
```

### Check Status
```bash
docker compose ps
```

### Run Commands Inside Container
```bash
docker compose exec openclaw openclaw config --section model
```

## Data Persistence

**During Normal Operation:**
- Container auto-restarts if it crashes (`restart: unless-stopped`)
- All data persists across restarts (sessions, config, everything)
- Changes are saved in the running container

**To Port to Another System:**

1. Create snapshot of current state:
```bash
docker commit openclaw openclaw:snapshot-$(date +%Y%m%d-%H%M%S)
```

2. Export snapshot:
```bash
docker save openclaw:snapshot-20260201-192105 | gzip > backup.tar.gz
```

3. On new machine, load and run:
```bash
docker load < backup.tar.gz
# Update image name in docker-compose.yml
docker compose up -d
```

The entire system (config, sessions, personality) transfers to the new machine.

## Access Points

- Gateway: http://YOUR_SERVER_IP:18789
- Browser Control: http://YOUR_SERVER_IP:18791

## Architecture

- Base: Ubuntu 24.04 LTS
- Runtime: Node.js 22
- OpenClaw: npm global install
- Persistence: Container filesystem (survives restarts)
- Portability: Docker snapshots

Simple. Complete. Portable.
