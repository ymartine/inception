FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=yamartin.42.fr"

COPY conf/nginx.conf /etc/nginx/sites-enabled/default

CMD ["nginx", "-g", "daemon off;"]