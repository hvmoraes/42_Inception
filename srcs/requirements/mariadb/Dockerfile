FROM debian:buster

RUN apt -y update && apt -y upgrade
RUN apt install -y 	mariadb-server \
			vim \
			procps

COPY ./conf/mysql.cnf /etc/mysql/mariadb.conf.d/mysql.cnf
COPY ./tools/mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb.sh

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
CMD ["mysqld_safe"]