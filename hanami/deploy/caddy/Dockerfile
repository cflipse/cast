from caddy:2-builder-alpine as builder

run xcaddy build \
      --with github.com/caddy-dns/digitalocean

from caddy:2-alpine

copy --from=builder /usr/bin/caddy /usr/bin/caddy
# Caddyfile is bind-mounted at deploy time (see deploy/update-caddy.sh and
# deploy/reload-caddy.sh), not baked in here, so editing it never requires
# an image rebuild. For standalone local testing, mount one explicitly:
#   docker run -v $(pwd)/test.Caddyfile:/etc/caddy/Caddyfile ...
