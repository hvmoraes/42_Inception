# Inception

A Docker-based WordPress infrastructure deploying Nginx, WordPress (PHP-FPM), and MariaDB as isolated containers with TLS, persistent volumes, and automated provisioning.

## Architecture

```
                 ┌──────────────┐
                 │   Browser    │
                 └──────┬───────┘
                        │ HTTPS :443
                 ┌──────▼───────┐
                 │    Nginx     │  TLS termination
                 │ (bullseye)   │  ssl_protocols TLSv1.3
                 └──────┬───────┘
                        │ FastCGI :9000
                 ┌──────▼───────┐
                 │  WordPress   │  PHP-FPM 7.4
                 │  + WP-CLI    │  Auto-install on first boot
                 └──────┬───────┘
                        │ TCP :3306
                 ┌──────▼───────┐
                 │   MariaDB    │  Persistent data volume
                 └──────────────┘
```

## Tech Stack

| Component | Image | Role |
|-----------|-------|------|
| Nginx | debian:bullseye | TLS reverse proxy → PHP-FPM |
| WordPress | debian:bullseye | PHP-FPM 7.4 + WP-CLI auto-setup |
| MariaDB | debian:bullseye | Database with health-checked startup |
| Volumes | Bind mounts | `/home/$USER/data/{wordpress,mariadb}` |

## Running

```bash
cp srcs/.env.example srcs/.env  # Fill with your credentials
make                            # Builds & starts all containers
```

Access at `https://localhost:443`

```bash
make down    # Stop containers
make clean   # Remove all containers, images, volumes, and data
make re      # Full rebuild
```

## Key Engineering Decisions

- **All images built from Debian, not pulled** ([srcs/requirements/](srcs/requirements/)): Per 42 subject requirements, each service is built from a base Debian image with explicit package installation — no pre-built WordPress or MariaDB images.

- **TLS-only with TLSv1.3** ([srcs/requirements/nginx/conf/nginx.conf](srcs/requirements/nginx/conf/nginx.conf)): Nginx is configured with `ssl_protocols TLSv1.3` only, `ssl_prefer_server_ciphers on`, and security headers (X-Frame-Options, X-Content-Type-Options, X-XSS-Protection).

- **WP-CLI automated provisioning** ([srcs/requirements/wordpress/tools/wp_conf.sh](srcs/requirements/wordpress/tools/wp_conf.sh)): WordPress is downloaded, configured, and the admin/test user created automatically on first container boot via WP-CLI, eliminating manual setup.

- **Docker secrets for credentials** ([srcs/docker-compose.yml](srcs/docker-compose.yml)): Database and WordPress passwords are stored as file-based Docker secrets rather than plain environment variables, keeping them out of process listings and container inspect output.

- **Services run as non-root** — MariaDB runs as `mysql` user (`mysqld_safe --user=mysql`), PHP-FPM workers run as `www-data`, and Nginx worker processes drop to `www-data` — following least-privilege principles.

- **Health checks on all services** — MariaDB checks via `mysqladmin ping`, Nginx via `curl -fsk https://localhost:443/`, WordPress via `php-fpm7.4 -t`. Docker Compose `restart: always` ensures recovery from transient failures.

- **Nginx logs to stdout/stderr** ([srcs/requirements/nginx/Dockerfile](srcs/requirements/nginx/Dockerfile)): Access and error logs are symlinked to `/dev/stdout` and `/dev/stderr`, integrating with `docker logs` instead of requiring log file access inside the container.

- **Portable Makefile** ([Makefile](Makefile)): Data directories use `$(USER)` variable instead of hardcoded usernames, making the project work on any machine without modification.
