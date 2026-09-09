*This project has been created as part of the 42 curriculum by yamartin*

## Description

Inception is a system administration project that involves setting up a small infrastructure using Docker and Docker Compose. The infrastructure consists of three services: NGINX (reverse proxy with TLS), WordPress (with PHP-FPM), and MariaDB (database), each running in its own container.

## Instructions

### Prerequisites
- Docker and Docker Compose installed
- A virtual machine running Debian

### Setup
1. Clone the repository:
```bash
git clone git@vogsphere.42paris.fr:vogsphere/intra-uuid-b6f86feb-63ec-4666-b561-c343e946b205-7126679-yamartin inception
cd inception
```

2. Copy `.env.example` to `.env` and fill in the values:
```bash
cp srcs/.env.example srcs/.env
vim srcs/.env
```

3. Launch the project:
```bash
make
```

4. Access the website at `https://yamartin.42.fr`

### Makefile commands
- `make` → build and start all services
- `make down` → stop all services
- `make clean` → stop and remove containers and images
- `make fclean` → full clean including volumes
- `make re` → rebuild everything from scratch

## Resources

### AI Usage
Claude (Anthropic) was used throughout this project to understand Docker concepts, debug configuration issues, and learn how the different services interact with each other. AI helped explain concepts like PID 1, volume mounting, network configuration, and PHP-FPM setup.

### Documentation consulted
- Docker official documentation
- WordPress developer documentation
- NGINX documentation
- MariaDB documentation
- Forum about Docker issues