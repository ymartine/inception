#!/bin/bash

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    mysqld --user=mysql --skip-grant-tables &
    sleep 3

    mysql -u root << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin -u root shutdown
fi

exec mysqld --user=mysql --bind-address=0.0.0.0