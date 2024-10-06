#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="prettygreenplants"
DEFAULT_WWW_USER_ID="1000"
DEFAULT_FLOW_CONTEXT="Development"

# Update system user if defined differently
if [ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]; then
	echo "Rename user \"${DEFAULT_WWW_USER}\" to \"${WWW_USER}\"!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}

	echo "Update \"www.conf\" to use \"${WWW_USER}\" user and group!"
	sed -i -e "s~user = ${DEFAULT_WWW_USER}~user = ${WWW_USER}~g" /etc/php/7.2/fpm/pool.d/www.conf
	sed -i -e "s~group = ${DEFAULT_WWW_USER}~group = ${WWW_USER}~g" /etc/php/7.2/fpm/pool.d/www.conf
fi

# Update uid of system user if defined differently
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Update \"${WWW_USER}\" user and group ID to \"${WWW_USER_ID}\"!"
	usermod --uid ${WWW_USER_ID} ${WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${WWW_USER}
fi

# Disable php info if not Development context
if [ "${FLOW_CONTEXT}" != "${DEFAULT_FLOW_CONTEXT}" ]; then
	echo "Hide php info for \"${FLOW_CONTEXT}\" context!"
	sed -i -e "s~expose_php = On~expose_php = Off~g" /etc/php/7.2/fpm/php.ini
fi

# Run normal command
exec "$@"
