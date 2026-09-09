# Inception

A complete LEMP infrastructure running in Docker, with every image built from
scratch — no official `nginx`, `wordpress` or `mariadb` images, no `:latest`
tags, no shortcuts.

Three services, three hand-written Dockerfiles, one isolated network, TLS only.

<!-- Dépose ta capture dans docs/ et décommente la ligne ci-dessous
![WordPress running over HTTPS](docs/screenshot.png)
-->

## Architecture

```
                    :443 (TLS only)
                          │
                    ┌─────▼─────┐
                    │   NGINX   │  reverse proxy, TLSv1.2/1.3
                    └─────┬─────┘
                          │ FastCGI :9000
                    ┌─────▼─────┐
                    │ WordPress │  PHP-FPM 8.2, installed via wp-cli
                    └─────┬─────┘
                          │ MySQL :3306
                    ┌─────▼─────┐
                    │  MariaDB  │
                    └───────────┘

              docker network: inception (bridge)
        volumes: bind-mounted to the host filesystem
```

NGINX is the only container exposed to the outside world. Port 80 is never
opened — the entire stack is HTTPS-only.

## What's actually in here

**Images built from `debian:bookworm`, not pulled ready-made.** Each service
installs and configures its own packages. This was the main constraint of the
project, and the reason it's more interesting than a three-line
`docker-compose.yml`.

**TLS certificate generated at build time.** OpenSSL produces a self-signed
RSA-2048 certificate inside the NGINX image, so the container is functional the
moment it starts, with no external setup step.

**PHP-FPM moved from a Unix socket to TCP.** By default Debian's PHP-FPM listens
on `/run/php/php8.2-fpm.sock`, which is unreachable from another container. The
pool config is rewritten at build time to listen on port 9000 instead, which is
what makes the NGINX to WordPress hop work across the Docker network.

**A real dependency wait, not just `depends_on`.** Compose only guarantees start
order, not readiness — WordPress would try to configure itself against a
database still initialising. The entrypoint polls MariaDB with `netcat` until
port 3306 answers, then proceeds.

**Idempotent provisioning.** The WordPress entrypoint checks `wp core
is-installed` before doing anything, so restarting the stack never re-runs the
installation or overwrites existing content. Admin and user accounts are created
through `wp-cli` from environment variables.

**No credentials in the repository.** Every secret is read from `srcs/.env`,
which is gitignored. `srcs/.env.example` documents the required variables with
empty values.

**PID 1 handled properly.** Each container runs its service in the foreground as
the main process (`nginx -g "daemon off;"`, `exec php-fpm8.2 -F`) rather than
daemonising behind a shell — so signals reach the actual service and containers
stop cleanly.

## Running it

Requires Docker and Docker Compose on a Linux host.

```bash
git clone git@github.com:ymartine/inception.git
cd inception

cp srcs/.env.example srcs/.env
$EDITOR srcs/.env          # fill in the passwords

make
```

Then add the domain to your hosts file and open it in a browser:

```bash
echo "127.0.0.1 yamartin.42.fr" | sudo tee -a /etc/hosts
```

The certificate is self-signed, so the browser will warn on first visit.

### Make targets

| Target | Effect |
|---|---|
| `make` | Build images and start the stack |
| `make down` | Stop the containers |
| `make clean` | Remove containers and images |
| `make fclean` | Full teardown, volumes included |
| `make re` | Rebuild from scratch |

## Notes

Volumes are bind-mounted to a fixed path on the host, defined in
`srcs/docker-compose.yml`. Adjust it to your own environment before running.

Built as part of the 42 curriculum. The constraints — no pre-built images, no
hardcoded credentials, no infinite loops or `tail -f` as PID 1, no `network:
host` or `--link` — are what make the project a systems administration exercise
rather than a Docker tutorial.

AI assistance (Claude) was used to understand Docker internals during
development, in particular PID 1 semantics, volume mounting and inter-container
networking.
