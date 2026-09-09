#!/bin/bash

until nc -z mariadb 3306; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if ! wp core is-installed --path=/var/www/html/wordpress --allow-root; then

wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb \
    --path=/var/www/html/wordpress \
    --allow-root

wp core install \
    --url=${DOMAIN_NAME} \
    --title="Inception" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --path=/var/www/html/wordpress \
    --allow-root

wp user create ${WP_USER} ${WP_USER_EMAIL} \
    --role=subscriber \
    --user_pass=${WP_USER_PASSWORD} \
    --path=/var/www/html/wordpress \
    --allow-root

fi

exec php-fpm8.2 -F