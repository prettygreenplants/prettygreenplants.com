#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
NC="\033[0m"

ERROR="0"

command -v ansible >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE is not installed. Please check REAME.md file."${NC} >&2; ERROR="1"; }
command ansible --version | grep 2.8. >/dev/null 2>&1 ||
	{ echo -e ${RED}"- ANSIBLE version 2.8.x is required. Please check REAME.md file."${NC} >&2; ERROR="1"; }

if [ ${ERROR} == "0" ]; then
	read -p "Are you sure (y/n)? " -r
	echo

  if [[ -z "${FROM_DATE}" ]]; then
      FROM_DATE=$(date '+%Y-%m-%d')
  fi

	if [[ ${REPLY} =~ ^[Yy]$ ]]; then
		LOCAL_BASE_PATH=`pwd`
		ansible-playbook ansible/playbook.yml --limit live --tags syncontent --extra-vars "base_dir=${LOCAL_BASE_PATH} from_date=${FROM_DATE}"
	fi
fi
