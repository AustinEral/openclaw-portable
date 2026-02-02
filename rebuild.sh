#!/bin/bash
set -e
cd /root/openclaw-home
echo "[$(date)] Starting rebuild..." >> /tmp/rebuild.log
docker compose down
docker compose build --pull
docker compose up -d
echo "[$(date)] Rebuild complete." >> /tmp/rebuild.log
