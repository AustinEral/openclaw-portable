# OpenClaw Portable Docker Setup

A completely portable, self-contained Docker deployment of OpenClaw AI assistant. This setup prioritizes simplicity and complete data persistence - when you backup, you get EVERYTHING.

## Design Philosophy

- **Simple and Complete**: No hybrid solutions, no clever optimizations
- **100% Portable**: Copy the Docker image = entire system moves
- **Save Everything**: No selective backups, capture all state
- **Location Independent**: Not coupled to any specific machine or network

## Quick Start

### Build the Image

```bash
cd /root/openclaw-home
docker build -t openclaw:latest .
```

### Run OpenClaw

```bash
docker run -d \
  --name openclaw \
  -e OPENCLAW_GATEWAY_TOKEN=your-secure-token \
  -p 18789:18789 \
  -p 18791:18791 \
  --restart unless-stopped \
  openclaw:latest
```

### Check Status

```bash
docker logs openclaw
docker ps | grep openclaw
```

## Access Points

- **Gateway**: http://YOUR_SERVER_IP:18789
- **Browser Control**: http://YOUR_SERVER_IP:18791

## Complete Backup & Restore

### Create a Backup

Save the entire container state (all data, configs, sessions, personality):

```bash
docker commit openclaw openclaw:backup-$(date +%Y%m%d-%H%M%S)
```

### Export for Transfer

```bash
docker save openclaw:backup-20260202-011812 | gzip > openclaw-backup.tar.gz
```

### Restore on Any Machine

```bash
# Load the image
docker load < openclaw-backup.tar.gz

# Run it
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -p 18791:18791 \
  --restart unless-stopped \
  openclaw:backup-20260202-011812
```

That's it. The entire system is now running exactly as it was on the original machine.

## System Management

### View Logs

```bash
docker logs openclaw -f
```

### Stop/Start

```bash
docker stop openclaw
docker start openclaw
```

### Restart

```bash
docker restart openclaw
```

### Remove Container (keeps image)

```bash
docker stop openclaw
docker rm openclaw
```

### List All Backups

```bash
docker images | grep openclaw
```

## Architecture

- **Base Image**: Ubuntu 24.04 LTS
- **Runtime**: Node.js 22
- **OpenClaw**: Latest version from npm
- **Ports**: 18789 (gateway), 18791 (browser control)
- **Persistence**: docker commit captures entire container state

## Files

- `Dockerfile` - Container definition
- `README.md` - This file

## Configuration

OpenClaw requires `OPENCLAW_GATEWAY_TOKEN` environment variable for authentication. Set it when running the container.

To use a different token:

```bash
docker stop openclaw
docker rm openclaw
docker run -d \
  --name openclaw \
  -e OPENCLAW_GATEWAY_TOKEN=new-token-here \
  -p 18789:18789 \
  -p 18791:18791 \
  --restart unless-stopped \
  openclaw:latest
```

## Scaling

To run multiple agents:

```bash
# Agent 1
docker run -d \
  --name openclaw-agent1 \
  -e OPENCLAW_GATEWAY_TOKEN=token1 \
  -p 18789:18789 \
  -p 18791:18791 \
  openclaw:latest

# Agent 2  
docker run -d \
  --name openclaw-agent2 \
  -e OPENCLAW_GATEWAY_TOKEN=token2 \
  -p 18889:18789 \
  -p 18891:18791 \
  openclaw:latest
```

Each agent is completely isolated with its own personality and sessions.

## Troubleshooting

### Container won't start

Check logs:
```bash
docker logs openclaw
```

### Port already in use

Change the port mapping:
```bash
docker run -d \
  --name openclaw \
  -e OPENCLAW_GATEWAY_TOKEN=token \
  -p 19789:18789 \
  -p 19791:18791 \
  openclaw:latest
```

### Need to reconfigure

Run onboarding inside the container:
```bash
docker exec -it openclaw openclaw onboard
```

## Why This Approach?

Previous attempts used systemd services with selective file persistence, leading to:
- Lost sessions during crashes
- Incomplete backups missing critical data
- Complex configuration management
- Location-dependent setups

This Docker approach eliminates all of that:
- One command to backup everything
- One command to restore anywhere
- No thinking about what's important
- Agent manages its own internals, we just persist it all

Simple. Complete. Portable.
