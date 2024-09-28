#!/bin/sh

if [ -f ./wp-config.php ]; then
    echo "WordPress is already configured."
else
    echo "[.] Downloading WordPress..."
    wget -qO - http://wordpress.org/latest.tar.gz | tar xz --strip-components=1

    echo "[.] Creating wp-config.php..."
    sed -e "s/database_name_here/$WP_DB_NAME/g" \
        -e "s/username_here/$WP_DB_USER/g" \
        -e "s/password_here/$WP_DB_PASS/g" \
        -e "s/localhost/$MYSQL_HOSTNAME/g" \
        wp-config-sample.php > wp-config.php

    chown www-data:www-data wp-config.php
    chmod 640 wp-config.php

    echo "WordPress files downloaded and 'wp-config.php' created."

    echo "[.] Verifying database connection..."
	sleep 6
    mysql -h $MYSQL_HOSTNAME -u $WP_DB_USER -p"$WP_DB_PASS" -e "SELECT 1;" || {
        echo "Error connecting to database.";
        exit 1;
    }
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F