#!/bin/sh

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="prettygreenplants"
DEFAULT_WWW_USER_ID="1000"
DEFAULT_FLOW_CONTEXT="Development"
DEFAULT_NGINX_HOST="local.prettygreenplants.com"
SELF_SINGED_SSL_CERTIFICATE="/etc/ssl/certs/prettygreenplants-self-signed.cert"
SELF_SINGED_SSL_KEY="/etc/ssl/private/prettygreenplants-self-signed.key"
LETSENCRYPT_SSL_CERTIFICATE="/etc/letsencrypt/live/prettygreenplants.com/fullchain.pem"
LETSENCRYPT_SSL_KEY="/etc/letsencrypt/live/prettygreenplants.com/privkey.pem"

# Update system user if defined differently
if [[ -n "${WWW_USER}" ]] && [[ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]]; then
	echo "Rename user \"${DEFAULT_WWW_USER}\" to \"${WWW_USER}\"!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}
	DEFAULT_WWW_USER="${WWW_USER}"
fi

# Update uid of system user if defined differently
if [[ -n "${WWW_USER_ID}" ]] && [[ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]]; then
	echo "Update \"${DEFAULT_WWW_USER}\" user and group ID to \"${WWW_USER_ID}\"!"
	usermod --uid ${WWW_USER_ID} ${DEFAULT_WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${DEFAULT_WWW_USER}
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
if [ "${USE_SELF_SIGNED_CERTIFICATE}" != true ]; then
	echo "Overwrite self-signed ssl certificates to letsencrypt!"
	sed -i -e "s~${SELF_SINGED_SSL_CERTIFICATE}~${LETSENCRYPT_SSL_CERTIFICATE}~g" /etc/nginx/conf.d/prettygreenplants.conf
	sed -i -e "s~${SELF_SINGED_SSL_KEY}~${LETSENCRYPT_SSL_KEY}~g" /etc/nginx/conf.d/prettygreenplants.conf
fi

# Run normal command
exec "$@"
