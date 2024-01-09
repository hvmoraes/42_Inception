FROM debian:buster

RUN apt update -y && apt upgrade -y && apt install mariadb-server -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/exec.sh /tmp/exec.sh

ENTRYPOINT ["sh",  "/tmp/exec.sh"]