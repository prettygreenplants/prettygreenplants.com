#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="prettygreenplants"
DEFAULT_WWW_USER_ID="1000"
DEFAULT_NGINX_HOST="prettygreenplants.local"
DEFAULT_WWW_ROOT="/var/www"
DEFAULT_FLOW_CONTEXT="Development"

if [ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]; then
	echo "Updating user ${DEFAULT_WWW_USER} to ${WWW_USER}!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}
fi

# Update uid of the owner
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Updating ${WWW_USER} user and group ID to ${WWW_USER_ID}!"
	usermod --uid ${WWW_USER_ID} ${WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${WWW_USER}
fi

if [ "${NGINX_HOST}" != "${DEFAULT_NGINX_HOST}" ]; then
	echo "Updating vhost to use the right domain!"
	sed -i -e "s~${DEFAULT_NGINX_HOST}~${NGINX_HOST}~g" /etc/nginx/conf.d/default.conf
fi

if [ "${WWW_ROOT}" != "${DEFAULT_WWW_ROOT}" ]; then
	echo "Updating vhost to use the right document root!"
	sed -i -e "s~${DEFAULT_WWW_ROOT}~${WWW_ROOT}~g" /etc/nginx/conf.d/default.conf
fi

if [ "${FLOW_CONTEXT}" != "${DEFAULT_FLOW_CONTEXT}" ]; then
	echo "Updating vhost to use the right context!"
	sed -i -e "s~${DEFAULT_FLOW_CONTEXT}~${FLOW_CONTEXT}~g" /etc/nginx/conf.d/default.conf
fi

# Run normal command
exec "$@"
