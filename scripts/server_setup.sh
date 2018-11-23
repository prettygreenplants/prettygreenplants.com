#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
NC="\033[0m"

ERROR="0"

command -v ansible >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command ansible --version | grep "2.5." >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE version 2.5 is required. Please check REAME.md file."${NC} >&2; ERROR="1"; }

if [ ${ERROR} == "0" ]; then
	ansible-playbook ansible/playbook.yml --limit live --tags packages
fi
