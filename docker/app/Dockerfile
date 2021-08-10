# Pull base image
FROM ubuntu:18.04

MAINTAINER Pretty Green Plants <info@prettygreenplants.com>

ENV DEBIAN_FRONTEND noninteractive

# Set timezone
ENV TZ=Asia/Phnom_Penh
RUN ln -nfs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Upgrade the base system
RUN apt-get update && apt-get upgrade -y -q --no-install-recommends

# Install packages as per recommendation (https://docs.docker.com/articles/dockerfile_best-practices/)
# And clean up APT
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ghostscript \
    imagemagick \
    locales \
    sendmail \
    sudo \
    php7.2-cli \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-xml \
    php-imagick \
    php-redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the locales
RUN locale-gen en_US.UTF-8 km_KH
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV WWW_USER prettygreenplants
ENV WWW_USER_ID 1000
ENV FLOW_CONTEXT Development

# Create webserver user and group
RUN adduser --system --shell /bin/bash --no-create-home --uid ${WWW_USER_ID} --group --disabled-password --disabled-login ${WWW_USER}

# Copy configuration files for php
COPY www.conf     /etc/php/7.2/fpm/pool.d/
COPY php-fpm.conf /etc/php/7.2/fpm/
COPY php.ini      /etc/php/7.2/fpm/
COPY php-cli.ini  /etc/php/7.2/cli/php.ini

RUN sed -i -e "s~###DEFAULT_WWW_USER###~${WWW_USER}~g" /etc/php/7.2/fpm/pool.d/www.conf

# Set entrypoint to fix volume mount permission
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/prettygreenplants

# Expose port and by default start php-fpm
EXPOSE 9000
CMD ["php-fpm7.2"]
