FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=644 ./conf/mysql.cnf /etc/mysql/mariadb.conf.d/mysql.cnf
COPY ./tools/mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb.sh

# Ensure mysql user owns data and run directories
RUN mkdir -p /var/run/mysqld /var/log/mysql \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
    CMD mysqladmin ping -h localhost || exit 1

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
CMD ["mysqld_safe", "--user=mysql"]