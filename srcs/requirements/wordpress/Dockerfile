FROM debian:bookworm

RUN apt-get update && apt-get install -y netcat-openbsd php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip wget && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz -C /var/www/html/ && \
    rm latest.tar.gz

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

CMD [ "/usr/local/bin/init.sh" ]
