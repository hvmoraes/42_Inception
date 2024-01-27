FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y && apt-get -y install \
	wget \
	curl \
	bash \
	php \
	php-cgi \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd php-cli \
	php-mbstring
RUN rm -rf /var/lib/apt/lists/*

# Install wp_cli and place in the right directory /usr/local/bin
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Copy .conf to html directory
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

RUN mkdir /run/php

# Copy the script and give rights to be executed
COPY ./tools/wp_conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_conf.sh
ENTRYPOINT ["/usr/local/bin/wp_conf.sh"]

WORKDIR /var/www/html/

EXPOSE 9000

# Launch PHP FPM in background and ignore deamonize from conf file (-F)
CMD ["/usr/sbin/php-fpm7.3", "-F"]