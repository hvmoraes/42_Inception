FROM debian:bullseye

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    bash \
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd \
    php-cli \
    php-mbstring \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir /run/php

COPY ./tools/wp_conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_conf.sh

WORKDIR /var/www/html

# Ensure www-data owns the working directory
RUN chown -R www-data:www-data /var/www/html /run/php

EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD php-fpm7.4 -t || exit 1

ENTRYPOINT ["/usr/local/bin/wp_conf.sh"]