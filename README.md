Requirements:
=============

curl
----

Verify with `curl -V` and if not yet installed, run:

	sudo apt-get install curl

git
---

Verify with `git --version` and if not yet installed, run:

	sudo apt-get install git

php
---

Verify with `php -v` and if not yet installed, run:

	sudo apt-get install php5-cli

composer
--------

Verify with `composer -V` and if not yet installed, run:

	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer
	php -r "unlink('composer-setup.php');"

Refer to <https://getcomposer.org/download/>

docker
------

Verify with `docker -v` and if not yet installed, follow <https://docs.docker.com/engine/installation/linux/ubuntulinux/>

docker-compose
--------------

Verify with `docker-compose -v` and if not yet installed, run:

	sudo curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

Refer to <https://docs.docker.com/compose/install/>

Installation
============

Get the code:

	git clone git@gitlab.com:visay/sokly.git ~/dev/sokly

Go into project directory:

	cd ~/dev/sokly

Check requirements by running the following command and you should get the message `- Everything looks good!`:

	./check_setup.sh

Install project dependencies:

	composer install --prefer-dist

Start docker containers:

	bin/dockerflow up -d

Migrate database:

	/bin/dockerflow run app ./flow doctrine:migrate

Import site:

	/bin/dockerflow run app ./flow site:import --package-key Neos.Demo

Create admin backend user:

	/bin/dockerflow run app ./flow user:create --roles=Administrator visay visay123 Visay Keo

Verify:

- Frontend: <http://0.0.0.0:8080>
- Backend: <http://0.0.0.0:8080/neos>

Deployment To Live
==================

Ansible
-------

Verify with `ansible --v` and if it is lower than 2.0 or is not yet installed, run:

	sudo add-apt-repository ppa:ansible/ansible -y
	sudo apt-get update
	sudo apt-get -y --force-yes install ansible=2.1.0.0-1ppa~trusty

Release
-------

	./release.sh
