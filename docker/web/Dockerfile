# Pull base image
FROM nginx:1.7

MAINTAINER Sokly Phal <sokly@visay.info>
MAINTAINER Visay Keo  <keo@visay.info>

ENV NGINX_HOST prettygreenplants.local

# Create webserver user and group
RUN adduser --system --shell /bin/bash --no-create-home --uid 1000 --group --disabled-password --disabled-login prettygreenplants

# Copy configuration files for nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx_vhost.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e "s~###DEFAULT_NGINX_HOST###~${NGINX_HOST}~g" /etc/nginx/conf.d/default.conf

# Set entrypoint to fix volume mount permission
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
