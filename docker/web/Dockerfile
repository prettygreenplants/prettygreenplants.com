# Pull base image
FROM nginx:1.7

MAINTAINER Sokly Phal <sokly@visay.info>
MAINTAINER Visay Keo  <keo@visay.info>

ENV WWW_USER prettygreenplants
ENV WWW_USER_ID 1000
ENV NGINX_HOST prettygreenplants.local
ENV WWW_ROOT /var/www
ENV FLOW_CONTEXT Development

# Create webserver user and group
RUN adduser --system --shell /bin/bash --no-create-home --uid ${WWW_USER_ID} --group --disabled-password --disabled-login ${WWW_USER}

# Copy configuration files for nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx_vhost.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e "s~DEFAULT_NGINX_HOST~${NGINX_HOST}~g;s~DEFAULT_WWW_ROOT~${WWW_ROOT}~g;s~DEFAULT_FLOW_CONTEXT~${FLOW_CONTEXT}~g" /etc/nginx/conf.d/default.conf

# Set entrypoint to fix volume mount permission
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
