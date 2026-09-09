# Developer Documentation

## Prerequisites
- Docker and Docker Compose installed
- Debian or Ubuntu system
- Make

## Project structure
inception/ contains Makefile, README.md, USER_DOC.md, DEV_DOC.md and a srcs/ folder.
srcs/ contains docker-compose.yml, .env and a requirements/ folder.
requirements/ contains three folders: nginx/, wordpress/ and mariadb/.
Each service folder contains a Dockerfile and a tools/ or conf/ subfolder with configuration files.

## Setup
1. Clone the repository
2. Create srcs/.env with required variables
3. Run make

## Makefile usage
- make : create data directories, add hosts entry, build and start all services
- make down : stop all containers
- make clean : stop containers and remove images
- make fclean : full cleanup including volumes and data directories
- make re : fclean + make

## Docker Compose commands
- docker compose ps : list containers
- docker compose logs : view logs
- docker compose down : stop services

## Data persistence
WordPress and MariaDB data are stored in:
- /home/yamartin/data/volume-wordpress
- /home/yamartin/data/volume-mariadb

These directories persist even after containers are stopped.

## Environment variables
All configuration is done via srcs/.env (not tracked by git).
Required variables: DOMAIN_NAME, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD, WP_ADMIN_USER, WP_ADMIN_PASSWORD, WP_ADMIN_EMAIL, WP_USER, WP_USER_PASSWORD, WP_USER_EMAIL