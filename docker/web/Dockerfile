# Pull base image
FROM nginx:1.7

MAINTAINER Sokly Phal <sokly@visay.info>
MAINTAINER Visay Keo  <keo@visay.info>

# Create webserver user and group
RUN adduser --system --shell /bin/bash --no-create-home --uid 1000 --group --disabled-password --disabled-login prettygreenplants

# Copy configuration files for nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx_vhost.conf /etc/nginx/conf.d/default.conf.template

# Set entrypoint to fix volume mount permission
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
