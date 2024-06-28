#!/bin/sh

if [ -f ./wp-config.php ]; then
    echo "WordPress is already configured."
else
    wget http://wordpress.org/latest.tar.gz
    tar xfz latest.tar.gz
    mv wordpress/* .
    rm -rf latest.tar.gz wordpress

    sed -e "s/database_name_here/$MYSQL_DATABASE/g" \
        -e "s/username_here/$MYSQL_USER/g" \
        -e "s/password_here/$MYSQL_PASSWORD/g" \
        -e "s/localhost/$MYSQL_HOSTNAME/g" \
        wp-config-sample.php > wp-config.php

    chown www-data:www-data wp-config.php
    chmod 640 wp-config.php

    echo "WordPress downloaded and configured."
fi

/usr/sbin/php-fpm7.4 -F 