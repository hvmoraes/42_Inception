#!/bin/bash

# Load secrets from Docker secrets (mounted files) if available,
# falling back to environment variables for backward compatibility.
if [ -f /run/secrets/mysql_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
fi
if [ -f /run/secrets/wp_db_pass ]; then
    WP_DB_PASS=$(cat /run/secrets/wp_db_pass)
fi

echo "[.] Starting MariaDB Service"
service mariadb start

# Readiness wait — poll until mysqld actually accepts connections
echo "[.] Waiting for MySQL to be ready ..."
for i in $(seq 1 30); do
    mysqladmin ping -h localhost --silent 2>/dev/null && break
    sleep 1
done

echo "[.] Running MySQL Instructions ..."
mysql -u root <<EOF
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
GRANT ALL ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
FLUSH PRIVILEGES;
USE $WP_DB_NAME;
EOF

echo "[.] Stopping MariaDB Service ..."
service mariadb stop

echo "[.] Running MySQL Daemon ..."
exec "$@"
