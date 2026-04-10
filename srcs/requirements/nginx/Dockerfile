FROM debian:bullseye

RUN apt-get update -y \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends nginx openssl curl \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/hcorrea-.crt \
        -keyout /etc/nginx/ssl/hcorrea-.key \
        -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42 School/OU=hcorrea-/CN=hcorrea-/"

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

# Redirect logs to stdout/stderr for docker logs integration
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Run as non-root (nginx worker processes will run as www-data)
RUN chown -R www-data:www-data /var/log/nginx /run/nginx /var/lib/nginx

EXPOSE 443

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD curl -fsk https://localhost:443/ || exit 1

CMD [ "nginx", "-g", "daemon off;" ]