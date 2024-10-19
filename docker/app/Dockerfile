# Pull base image
FROM ubuntu:24.04

LABEL com.prettygreenplants.vendor="Pretty Green Plants" \
      com.prettygreenplants.email="info@prettygreenplants.com"

ENV DEBIAN_FRONTEND=noninteractive

# Upgrade the base system
RUN apt-get update && apt-get upgrade -y -q --no-install-recommends && apt-get install tzdata

# Set timezone
ENV TZ=Asia/Phnom_Penh
RUN ln -nfs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages as per recommendation (https://docs.docker.com/articles/dockerfile_best-practices/)
# And clean up APT
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ghostscript \
    imagemagick \
    locales \
    sendmail \
    sudo \
    php8.3-cli \
    php8.3-curl \
    php8.3-fpm \
    php8.3-gd \
    php8.3-ldap \
    php8.3-mbstring \
    php8.3-mysql \
    php8.3-xml \
    php8.3-imagick \
    php8.3-redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the locales
RUN locale-gen en_US.UTF-8 km_KH
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV WWW_USER_ID 1000
ENV FLOW_CONTEXT Development

# Rename ubuntu user to prettygreenplants
RUN usermod -d /home/prettygreenplants -l prettygreenplants -c "Pretty Green Plants" ubuntu
RUN groupmod -n prettygreenplants ubuntu

# Copy configuration files for php
COPY www.conf     /etc/php/8.3/fpm/pool.d/
COPY php-fpm.conf /etc/php/8.3/fpm/
COPY php.ini      /etc/php/8.3/fpm/
COPY php-cli.ini  /etc/php/8.3/cli/php.ini

# Set entrypoint to fix volume mount permission
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/prettygreenplants

# Expose port and by default start php-fpm
EXPOSE 9000
CMD ["php-fpm8.3"]
