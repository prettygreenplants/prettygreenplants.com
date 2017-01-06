#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="prettygreenplants"
DEFAULT_WWW_USER_ID="1000"

if [ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]; then
	echo "Updating user ${DEFAULT_WWW_USER} to ${WWW_USER}!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}

	echo "Updating www.conf to use the right user and group!"
	sed -i -e "s~user = ${DEFAULT_WWW_USER}~user = ${WWW_USER}~g" /etc/php/7.0/fpm/pool.d/www.conf
	sed -i -e "s~group = ${DEFAULT_WWW_USER}~group = ${WWW_USER}~g" /etc/php/7.0/fpm/pool.d/www.conf
fi

# Update uid of the owner
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Updating ${WWW_USER} user and group ID to ${WWW_USER_ID}!"
	usermod --uid ${WWW_USER_ID} ${WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${WWW_USER}
fi

# Run normal command
exec "$@"
