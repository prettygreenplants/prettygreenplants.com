#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

ERROR="0"

command -v curl >/dev/null 2>&1 ||
	{ echo -e ${RED}"- CURL is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v git >/dev/null 2>&1 ||
	{ echo -e ${RED}"- GIT is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v php >/dev/null 2>&1 ||
	{ echo -e ${RED}"- PHP is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v composer >/dev/null 2>&1 ||
	{ echo -e ${RED}"- COMPOSER is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v docker >/dev/null 2>&1 ||
	{ echo -e ${RED}"- DOCKER is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command -v docker-compose >/dev/null 2>&1 ||
	{ echo -e ${RED}"- DOCKER-COMPOSE is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }

if [ ${ERROR} == "0" ]; then
	echo -e ${GREEN}"- Everything looks good!"${NC}
fi
