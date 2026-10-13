#!/usr/bin/env sh
# Idempotent bootstrap for the shared VM infrastructure: Docker, Swarm,
# the overlay network, the local registry, and the front-door Caddy.
#
# Run this from your LOCAL machine, not on the VM:
#   deploy/bootstrap.sh you@your-droplet-ip
#
# Only two steps actually need a shell on the box (installing Docker,
# creating /srv/cast) and those go over plain SSH. The swarm/network/
# registry/Caddy steps are Docker API calls made through a local `docker
# context` pointed at the VM's daemon. The Caddy image itself is built
# HERE, on your machine, not on the VM's daemon — it's pushed to the
# VM's registry through an SSH tunnel instead, so the host never spends
# its own CPU/disk compiling it. The VM never needs a checkout of this repo.
set -eu

HOST=${1:?"usage: deploy/bootstrap.sh user@host"}
CONTEXT=vm
NETWORK=swarm-net
REGISTRY_SERVICE=registry
REGISTRY_PORT=5555
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOCKER="docker --context ${CONTEXT}"

log() {
  printf '==> %s\n' "$1"
}

# 1. Install Docker on the VM if not already present (host-level, via SSH).
if ssh "$HOST" 'command -v docker' >/dev/null 2>&1; then
  log "Docker already installed on ${HOST}, skipping"
else
  log "Installing Docker on ${HOST}"
  ssh "$HOST" 'curl -fsSL https://get.docker.com | sh'
fi

# Point a local Docker context at the VM's daemon (over SSH). Every step
# below talks to the VM through this context instead of a remote shell.
if docker context inspect "$CONTEXT" >/dev/null 2>&1; then
  log "Docker context ${CONTEXT} already exists, skipping"
else
  log "Creating docker context ${CONTEXT} -> ${HOST}"
  docker context create "$CONTEXT" --docker "host=ssh://${HOST}"
fi

# 2. docker swarm init, only if this node isn't already a manager.
if $DOCKER info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null | grep -q active; then
  log "Already part of a swarm, skipping swarm init"
else
  log "Initializing swarm"
  $DOCKER swarm init
fi

# 3. Create the overlay network, if it doesn't already exist.
if $DOCKER network ls --format '{{.Name}}' | grep -qx "$NETWORK"; then
  log "Network ${NETWORK} already exists, skipping"
else
  log "Creating overlay network ${NETWORK}"
  $DOCKER network create --driver overlay --attachable "$NETWORK"
fi

# 4. Deploy the shared registry, bound to 127.0.0.1 only (never public).
if $DOCKER service ls --format '{{.Name}}' | grep -qx "$REGISTRY_SERVICE"; then
  log "Service ${REGISTRY_SERVICE} already running, skipping"
else
  log "Deploying registry on 127.0.0.1:${REGISTRY_PORT}"
  $DOCKER service create \
    --name "$REGISTRY_SERVICE" \
    --network "$NETWORK" \
    --publish "published=${REGISTRY_PORT},target=5000,mode=host" \
    --constraint 'node.role==manager' \
    --mount type=volume,source=registry-data,destination=/var/lib/registry \
    registry:2
fi

# 5. Deploy the front-door Caddy from Step 3 (idempotent: creates the
# service on first run, rolls out an updated image on later runs).
"${SCRIPT_DIR}/update-caddy.sh" "$HOST"

# 6. Create this app's host-side root directory (host-level, via SSH).
if ssh "$HOST" '[ -d /srv/cast ]'; then
  log "/srv/cast already exists, skipping"
else
  log "Creating /srv/cast"
  ssh "$HOST" 'sudo mkdir -p /srv/cast && sudo chown "$(id -u):$(id -g)" /srv/cast'
fi

log "Bootstrap complete"

