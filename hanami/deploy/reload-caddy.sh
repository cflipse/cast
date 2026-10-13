#!/usr/bin/env sh
# Push an edited front-door Caddyfile to the VM and hot-reload Caddy --
# no image rebuild, no container restart, no dropped connections. Use
# this for routing/TLS changes in deploy/caddy/Caddyfile itself. For a
# Dockerfile/plugin change or a Caddy version bump, use
# deploy/update-caddy.sh instead.
#
#   deploy/reload-caddy.sh you@your-droplet-ip
set -eu

HOST=${1:?"usage: deploy/reload-caddy.sh user@host"}
CONTEXT=vm
CADDY_SERVICE=caddy
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOCKER="docker --context ${CONTEXT}"

log() {
  printf '==> %s\n' "$1"
}

log "Copying Caddyfile to ${HOST}:/srv/cast/caddy/Caddyfile"
ssh "$HOST" 'mkdir -p /srv/cast/caddy/branches'
scp "${SCRIPT_DIR}/caddy/Caddyfile" "${HOST}:/srv/cast/caddy/Caddyfile"

CONTAINER_ID=$($DOCKER ps --filter "name=${CADDY_SERVICE}" --format '{{.ID}}' | head -n1)
if [ -z "$CONTAINER_ID" ]; then
  echo "No running ${CADDY_SERVICE} container found -- deploy it first with deploy/update-caddy.sh" >&2
  exit 1
fi

log "Reloading Caddy config (zero-downtime)"
$DOCKER exec "$CONTAINER_ID" caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile

log "Reload complete"
