# Pull base image
FROM ubuntu:14.04

MAINTAINER Sokly Phal <sokly@visay.info>
MAINTAINER Visay Keo  <keo@visay.info>

# Set the locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Upgrade the base system
RUN apt-get update && apt-get upgrade -y -q --no-install-recommends && apt-get install -y --no-install-recommends software-properties-common

# Add ppa for PHP 7.0
RUN apt-get install -y language-pack-en-base && LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php

# Install packages as per recommendation (https://docs.docker.com/articles/dockerfile_best-practices/)
# And clean up APT
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sqlite3 \
    imagemagick \
    ghostscript \
    sendmail \
    php7.0-fpm \
    php7.0-cli \
    php7.0-mysql \
    php7.0-gd \
    php7.0-mbstring \
    php7.0-xml \
    php7.0-curl \
    php7.0-ldap \
    php7.0-sqlite3 \
    php7.0-imagick \
    php7.0-redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create webserver user and group
RUN adduser --system --shell /bin/bash --no-create-home --uid 1000 --group --disabled-password --disabled-login prettygreenplants

# Copy configuration files for php
COPY Configuration/Docker/www.conf     /etc/php/7.0/fpm/pool.d/
COPY Configuration/Docker/php-fpm.conf /etc/php/7.0/fpm/
COPY Configuration/Docker/php.ini      /etc/php/7.0/fpm/
COPY Configuration/Docker/php-cli.ini  /etc/php/7.0/cli/php.ini

# Set entrypoint to fix volume mount permission
COPY Configuration/Docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Set workdir to project root
WORKDIR /var/www

# Expose port and by default start php-fpm
EXPOSE 9000
CMD ["php-fpm7.0"]
