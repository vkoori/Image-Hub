################## base_php ##################
FROM php:8.4-fpm-alpine3.22 AS base_php

# Set timezone
ENV TZ=Asia/Tehran

# PHP modules
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
    mysqli \
    pdo_mysql \
    exif \
    pcntl \
    bcmath \
    sockets \
    timezonedb \
    redis \
    @composer \
    gd \
    soap \
    zip \
    xsl \
    csv \
    openswoole \
    && rm -f /usr/local/bin/install-php-extensions

# OS dependencies
RUN apk update && apk add --no-cache \
    git \
    supervisor \
    tzdata \
    vim \
    wget \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && rm -rf /var/cache/apk/*
