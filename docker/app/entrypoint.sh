#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="prettygreenplants"

if [ -z "${WWW_USER_ID}" ]; then
	echo "Environment variable WWW_USER_ID needs to be set for mounting permission!"
	exit 1
fi

if [ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]; then
	echo "Updating user ${DEFAULT_WWW_USER} to ${WWW_USER}!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}

	echo "Updating www.conf to use the right user and group!"
	sed -i -e "s~${DEFAULT_WWW_USER}~${WWW_USER}~g" /etc/php/7.0/fpm/pool.d/www.conf
fi

# Update uid of the owner
DEFAULT_WWW_USER_ID=$(id -u ${WWW_USER})
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Updating ${WWW_USER} user and group ID to ${WWW_USER_ID}!"
	usermod --uid ${WWW_USER_ID} ${WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${WWW_USER}
fi

# Run normal command
exec "$@"
