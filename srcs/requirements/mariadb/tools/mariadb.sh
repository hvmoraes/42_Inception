#!/bin/bash

echo "[.] Starting MySQL Service"
service mysql start

echo "[.] Writing MySQL Instructions"
cat << EOF > mariadb.sql
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASS';
GRANT ALL ON $WP_DB_NAME.* TO '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASS';
FLUSH PRIVILEGES;
USE $WP_DB_NAME;
CREATE TABLE IF NOT EXISTS info (name VARCHAR(255), level INT);
INSERT INTO info (name, level) VALUES ('amait-ou', 6);
EOF

echo "[.] Running MySQL Instructions ..."
mysql -u root < mariadb.sql

echo "[.] Stopping MySQL Service ..."
service mysql stop

echo "[.] Running MySQL Daemon ..."
exec $@