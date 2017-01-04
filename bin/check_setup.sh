#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

ERROR="0"
WARNING="0"

command -v curl >/dev/null 2>&1 ||
	{ echo -e ${RED}"- CURL is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v git >/dev/null 2>&1 ||
	{ echo -e ${RED}"- GIT is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v php >/dev/null 2>&1 ||
	{ echo -e ${RED}"- PHP is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command php --version | grep "PHP 7.0." >/dev/null 2>&1 ||
	{ echo -e ${RED}"- PHP version 7.0 is required. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v composer >/dev/null 2>&1 ||
	{ echo -e ${RED}"- COMPOSER is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v docker >/dev/null 2>&1 ||
	{ echo -e ${RED}"- DOCKER is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v docker-compose >/dev/null 2>&1 ||
	{ echo -e ${RED}"- DOCKER-COMPOSE is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v ansible >/dev/null 2>&1 ||
	{ echo -e ${YELLOW}"- ANSIBLE is not installed. Please check REAME.md file."${NC} >&2; WARNING="1"; }
command ansible --version | grep 2 >/dev/null 2>&1 ||
	{ echo -e ${YELLOW}"- ANSIBLE version 2 or higher is only required when deployment. Please check REAME.md file."${NC} >&2; WARNING="1"; }

if [ ${ERROR} == "0" ]; then
	if [ ${WARNING} == "0" ]; then
		echo -e ${GREEN}"+ Everything looks good!"${NC}
	else
		echo
		echo -e ${GREEN}"+ Your local environment looks good for development!"${NC}
		echo -e ${YELLOW}"+ Anyway, there may be issues when deploying to live!"${NC}
	fi
fi
