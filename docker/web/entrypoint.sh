#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

# Check if nginx host var is set, otherwise return error
if [ -z "${NGINX_HOST}" ]; then
	echo "NGINX_HOST environment variable is not set!"
	exit 1
else
	# Get id of the owner
	if [ ! -z "${HOST_USER_ID}" ]; then
		echo "Updating prettygreenplants user and group ID to ${HOST_USER_ID}!"
		usermod --uid ${HOST_USER_ID} prettygreenplants
		groupmod --gid ${HOST_USER_ID} prettygreenplants
	fi

	FLOW_CONTEXT=${FLOW_CONTEXT:=Development}
	sed -e "s~NGINX_HOST~${NGINX_HOST}~g;s~FLOW_CONTEXT~${FLOW_CONTEXT}~g" /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

# Run normal command
exec "$@"
