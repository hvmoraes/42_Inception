FROM debian:bullseye

RUN apt-get update -y \
        && apt-get upgrade -y \
        && apt-get install nginx openssl -y

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/hcorrea-.crt \
        -keyout /etc/nginx/ssl/hcorrea-.key \
        -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42 School/OU=hcorrea-/CN=hcorrea-/"

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]