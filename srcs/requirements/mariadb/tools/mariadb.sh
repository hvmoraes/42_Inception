#!/bin/sh

set -e

service mariadb start

sleep 5

# Grant privileges and create database and user
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
echo "CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
echo "CREATE USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
echo "GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%'; FLUSH PRIVILEGES;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"

service mariadb stop

# Execute command passed to the script (e.g., starting another process)
exec "$@"