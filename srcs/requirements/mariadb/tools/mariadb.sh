#!/bin/sh

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

service mariadb start

sleep 5

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"

echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"

echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
echo "CREATE USER '$MYSQL_ADMIN'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"

echo "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
echo "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_ADMIN'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"

service mariadb stop

exec "$@"