FROM aisberg/base-alpine:3.7

ENV INIT=supervisor

# for informations on Nginx modules see: https://www.nginx.com/resources/wiki/modules/
RUN apk add --update --no-cache --no-progress \
        openssl \
        nginx \
        nginx-mod-http-cache-purge \
        nginx-mod-http-fancyindex \
        nginx-mod-http-headers-more \
        nginx-mod-http-image-filter \
        nginx-mod-http-lua \
        nginx-mod-http-nchan \
        nginx-mod-http-perl \
        nginx-mod-http-redis2 \
        nginx-mod-http-upload-progress \
        nginx-mod-http-upstream-fair \
        nginx-mod-http-xslt-filter \
        nginx-mod-mail \
        nginx-mod-stream &&\
    `#---- directories and files ----#` &&\
    rm -rf /var/www/* /etc/nginx/conf.d/* &&\
    ln -sf /dev/stdout /var/lib/nginx/logs/access.log &&\
    ln -sf /dev/stderr /var/lib/nginx/logs/error.log &&\
    workdirs \
        /etc/nginx \
        /etc/ssl/private \
        /var/lib/nginx \
        /var/lib/nginx/client_body_temp \
        /var/run/nginx \
        /var/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

EXPOSE 8080 8443

ARG CREATED
LABEL org.opencontainers.image.title="Nginx" \
    org.opencontainers.image.version="1.12.2" \
    org.opencontainers.image.description="Nginx is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server" \
    org.opencontainers.image.url="http://nginx.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx" \
    org.opencontainers.image.created="$CREATED"