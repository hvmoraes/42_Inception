FROM debian:buster

RUN apt update -y && apt upgrade -y && apt install nginx openssl -y

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -newkey rsa:4096 \
	-x509 -sha256 -days 365 -nodes \
	-subj "/C=PT/L=Lisbon/O=42/CN=hcorrea-.42.fr" \
	-out /etc/nginx/ssl/hcorrea-.crt \
	-keyout /etc/nginx/ssl/hcorrea-.key

COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]