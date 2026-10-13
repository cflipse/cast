#!/usr/bin/env sh
# Build the front-door Caddy image locally, push it to the VM's registry
# through an SSH tunnel, and roll it out on the VM. Also provisions
# /srv/cast/caddy/{Caddyfile,branches/} on first run, since the service
# bind-mounts both rather than baking the Caddyfile into the image.
#
#   deploy/update-caddy.sh you@your-droplet-ip
#
# Safe to run any time: creates the `caddy` service on first run, rolls
# out a new image on every later run (whether that's a Dockerfile/plugin
# change, or just picking up a newer upstream Caddy). For a Caddyfile-only
# edit, use deploy/reload-caddy.sh instead — no rebuild needed. Called by
# bootstrap.sh for the initial install; run it directly for updates
# afterwards.
set -eu

HOST=${1:?"usage: deploy/update-caddy.sh user@host"}
CONTEXT=vm
NETWORK=swarm-net
REGISTRY_PORT=5555
CADDY_SERVICE=caddy
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOCKER="docker --context ${CONTEXT}"

# Tag by content (git SHA, same convention bin/deploy uses for app
# images) so every build gets a distinct tag. A reused static tag (e.g.
# caddy:bootstrap) makes `docker service update --image` a silent no-op,
# since Swarm only notices a change when the tag itself differs.
TAG=$(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || date +%s)
CADDY_IMAGE="localhost:${REGISTRY_PORT}/caddy:${TAG}"

log() {
  printf '==> %s\n' "$1"
}

# Build on THIS machine, not the VM's daemon, so the host never spends
# its own CPU/disk compiling images.
log "Building front-door Caddy image locally (${CADDY_IMAGE})"
docker build -t "$CADDY_IMAGE" "${SCRIPT_DIR}/caddy"

log "Ensuring /srv/cast/caddy/branches exists and Caddyfile is current"
ssh "$HOST" 'mkdir -p /srv/cast/caddy/branches'
scp "${SCRIPT_DIR}/caddy/Caddyfile" "${HOST}:/srv/cast/caddy/Caddyfile"

log "Tunneling to the registry and pushing"
ssh -fNL "${REGISTRY_PORT}:localhost:${REGISTRY_PORT}" "$HOST"
TUNNEL_PID=$(pgrep -f "ssh -fNL ${REGISTRY_PORT}:localhost:${REGISTRY_PORT} ${HOST}")
trap '[ -n "${TUNNEL_PID:-}" ] && kill "$TUNNEL_PID" 2>/dev/null' EXIT
docker push "$CADDY_IMAGE"
kill "$TUNNEL_PID" 2>/dev/null
trap - EXIT
unset TUNNEL_PID

if $DOCKER service ls --format '{{.Name}}' | grep -qx "$CADDY_SERVICE"; then
  log "Rolling out ${CADDY_IMAGE} to existing ${CADDY_SERVICE} service"
  $DOCKER service update --image "$CADDY_IMAGE" "$CADDY_SERVICE"
else
  log "Creating ${CADDY_SERVICE} service"
  $DOCKER service create \
    --name "$CADDY_SERVICE" \
    --network "$NETWORK" \
    --publish published=80,target=80 \
    --publish published=443,target=443 \
    --mount type=volume,source=caddy-data,destination=/data \
    --mount type=volume,source=caddy-config,destination=/config \
    --mount type=bind,source=/srv/cast/caddy/Caddyfile,destination=/etc/caddy/Caddyfile \
    --mount type=bind,source=/srv/cast/caddy/branches,destination=/etc/caddy/branches \
    "$CADDY_IMAGE"
fi

log "Caddy update complete"
