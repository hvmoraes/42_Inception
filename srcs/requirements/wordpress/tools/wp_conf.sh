#!/bin/sh

if [ -f ./wp-config.php ]; then
    echo "WordPress is already configured."
else
    wget http://wordpress.org/latest.tar.gz
    tar xfz latest.tar.gz
    mv wordpress/* .
    rm -rf latest.tar.gz wordpress

    sed -e "s/database_name_here/$WP_DB_NAME/g" \
        -e "s/username_here/$WP_DB_USER/g" \
        -e "s/password_here/$WP_DB_PASS/g" \
        -e "s/localhost/$MYSQL_HOSTNAME/g" \
        wp-config-sample.php > wp-config.php

    chown www-data:www-data wp-config.php
    chmod 640 wp-config.php

    echo "WordPress files downloaded and 'wp-config.php' created."

    # Verify database connection
    mysql -h $MYSQL_HOSTNAME -u $WP_DB_USER -p"$WP_DB_PASS" -e "SELECT 1;" || {
        echo "Error connecting to database.";
        exit 1;
    }

    if [ ! -f "/var/www/html/index.html" ]; then
        wp --allow-root core download
        wp --allow-root config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$MYSQL_HOSTNAME --dbcharset="utf8" --dbcollate="utf8_general_ci"
        wp --allow-root core install --url=$DOMAIN/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_MAIL
        wp --allow-root user create $WP_USER $WP_MAIL --role=author --user_pass=$WP_PASS
        wp --allow-root theme install inspiro --activate
        wp --allow-root plugin update --all 

        echo "WordPress configured."
    fi
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F