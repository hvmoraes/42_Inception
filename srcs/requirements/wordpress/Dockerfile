FROM debian:bullseye

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
	wget \
	curl \
	bash \
	php \
	php-cgi \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd \
	php-cli \
	php-mbstring

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d

RUN mkdir /run/php

COPY ./tools/wp_conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_conf.sh
ENTRYPOINT ["/usr/local/bin/wp_conf.sh"]

WORKDIR /var/www/html

EXPOSE 9000