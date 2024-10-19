#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER_ID="1000"
DEFAULT_FLOW_CONTEXT="Development"

# Update uid of prettygreenplants user if defined differently
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Update prettygreenplants user and group ID to \"${WWW_USER_ID}\"!"
	usermod --uid ${WWW_USER_ID} prettygreenplants
	groupmod --gid ${WWW_USER_ID} prettygreenplants
fi

# Disable php info if not Development context
if [ "${FLOW_CONTEXT}" != "${DEFAULT_FLOW_CONTEXT}" ]; then
	echo "Hide php info for \"${FLOW_CONTEXT}\" context!"
	sed -i -e "s~expose_php = On~expose_php = Off~g" /etc/php/8.3/fpm/php.ini
	sed -i -e "s~expose_php = On~expose_php = Off~g" /etc/php/8.3/cli/php.ini
fi

# Run normal command
exec "$@"
