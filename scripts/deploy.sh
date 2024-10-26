#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
NC="\033[0m"

ERROR="0"
STAGE="$1"

command -v ansible >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command ansible --version | grep "2.10." >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE version 2.10 is required. Please check REAME.md file."${NC} >&2; ERROR="1"; }

# If stage is not set anywhere, throw error
if [ -z "${STAGE}" ]; then
	echo -e ${RED}"- STAGE is not set. Please check REAME.md file."${NC} >&2
	ERROR="1"
fi

if [ ${ERROR} == "0" ]; then
	read -p "Are you sure to deploy to ${STAGE} (y/n)? " -r
	echo
	if [[ ${REPLY} =~ ^[Yy]$ ]]; then
		ansible-playbook ansible/playbook.yml --limit ${STAGE} --tags deploy -vvv
	fi
fi
