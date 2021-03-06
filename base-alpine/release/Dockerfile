FROM golang:alpine as build
WORKDIR /usr/local/src
RUN apk add --update --no-cache --no-progress git \
    && go get -v -u github.com/ochinchina/supervisord \
    && CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-extldflags -static" -o /usr/bin/supervisord github.com/ochinchina/supervisord

#-------------------------------------------------------------------------------

FROM alpine:3.12

ARG LANG=en_US.UTF-8
ARG ALPINE_MIRROR=http://dl-cdn.alpinelinux.org/alpine/
ENV LANG=$LANG \
    LANGUAGE=$LANG \
    LC_ALL=$LANG \
    ALPINE_MIRROR=$ALPINE_MIRROR \
    TZ=:/etc/localtime

RUN set -x \
    \
    # add container user (cu)
    && adduser -S -u 999 -s /bin/bash -G root cu \
    && chmod g+rwX,o-rwx /home/cu \
    \
    # install software
    && sed -i "s%http://dl-cdn.alpinelinux.org/alpine/%$ALPINE_MIRROR%g" /etc/apk/repositories \
    && apk update && apk upgrade \
    && apk add --no-cache --no-progress  \
        bash \
        ca-certificates \
        curl \
        gnupg \
        nano \
        py3-pip \
        python3 \
        tini \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && pip3 install --upgrade pip \
    && pip3 install wheel \
    && pip3 install schedule \
    && pip3 install Templer \
    \
    # cleanup
    && rm -rf /var/cache/apk/*

COPY --from=build /usr/bin/supervisord /usr/bin/supervisord
COPY provision /provision
COPY static /
RUN chmod 0755 /entrypoint /usr/bin/workdirs /usr/bin/schedule_program \
    && find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    \
    # prepare working directories
    && workdirs \
        /container/log \
        /etc/supervisor \
        /usr/local/src \
        /var/run/container

ENTRYPOINT ["/entrypoint"]
CMD ["run"]

LABEL org.opencontainers.image.title="Base Image - Alpine Linux" \
    org.opencontainers.image.version="3.12" \
    org.opencontainers.image.description="A base image build upon Alpine Linux" \
    org.opencontainers.image.url="https://www.alpinelinux.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/base"
