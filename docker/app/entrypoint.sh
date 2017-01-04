#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

# Get id of the owner
if [ ! -z "${HOST_USER_ID}" ]; then
	echo "Updating prettygreenplants user and group ID to ${HOST_USER_ID}!"
	usermod --uid ${HOST_USER_ID} prettygreenplants
	groupmod --gid ${HOST_USER_ID} prettygreenplants
fi

# Run normal command
exec "$@"
