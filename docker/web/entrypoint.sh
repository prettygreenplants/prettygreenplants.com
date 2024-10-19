#!/bin/sh

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER_ID="1000"
DEFAULT_FLOW_CONTEXT="Development"
DEFAULT_NGINX_HOST="local.prettygreenplants.com"

# Update uid of prettygreenplants user if defined differently
if [[ -n "${WWW_USER_ID}" ]] && [[ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]]; then
	echo "Update \"prettygreenplants\" user and group ID to \"${WWW_USER_ID}\"!"
	usermod --uid ${WWW_USER_ID} prettygreenplants
	groupmod --gid ${WWW_USER_ID} prettygreenplants
fi

# Update hostname if defined differently
if [ "${NGINX_HOST}" != "${DEFAULT_NGINX_HOST}" ]; then
	echo "Set Neos hostname to \"${NGINX_HOST}\"!"
	sed -i -e "s~${DEFAULT_NGINX_HOST}~${NGINX_HOST}~g" /etc/nginx/conf.d/prettygreenplants.conf
fi

# Update flow context if defined differently
if [[ -n "${FLOW_CONTEXT}" ]] && [[ "${FLOW_CONTEXT}" != "${DEFAULT_FLOW_CONTEXT}" ]]; then
	echo "Set Flow context to \"${FLOW_CONTEXT}\" context!"
	sed -i -e "s~FLOW_CONTEXT     ${DEFAULT_FLOW_CONTEXT}~FLOW_CONTEXT     ${FLOW_CONTEXT}~g" /etc/nginx/conf.d/prettygreenplants.conf
fi

# Update ssl certificate and key if defined differently
if [ "${ENABLE_HTTPS}" != False ]; then
	echo "Configure vhost for self-signed ssl certificates!"
	sed -i -e "s~listen 80~listen 443 ssl~g" /etc/nginx/conf.d/prettygreenplants.conf
  sed -i -e "s~return 301 http~return 301 https~g" /etc/nginx/conf.d/prettygreenplants.conf
	sed -i -e "s~\#ssl_certificate~ssl_certificate~g" /etc/nginx/conf.d/prettygreenplants.conf
fi

# Disable server info if not Development context
if [ "${FLOW_CONTEXT}" != "${DEFAULT_FLOW_CONTEXT}" ]; then
	echo "Hide server info for \"${FLOW_CONTEXT}\" context!"
	sed -i -e "s~server_tokens on~server_tokens off~g" /etc/nginx/nginx.conf
fi

# Run normal command
exec "$@"
