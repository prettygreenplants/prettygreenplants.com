Dev Requirements:
=================

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

Verify with `php -v` and if not yet installed or not version 7.0, run:

	sudo apt-get install php7.0-cli

php extensions
--------------

Make sure these extensions are installed:

- mbstring
- dom

The following extension is recommended to speed thing up but not required:

- zip

Verify with `php -m` and see if any of them are not in the list, re-install all with:

	sudo apt-get install php7.0-mbstring php7.0-xml php7.0-zip

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

Additionally, add current Linux user to docker group and restart the machine so docker can be run as normal user.

docker-compose
--------------

Verify with `docker-compose -v` and if not yet installed, run:

	sudo curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

Refer to <https://docs.docker.com/compose/install/>

Ansible
-------

Verify with `ansible --version` and if it is not version 2.5 or is not yet installed, run:

	sudo add-apt-repository ppa:ansible/ansible -y
	sudo apt-get update
	sudo apt-get -y --force-yes install ansible

Go
--

Verify with `go version` and if it is not yet installed, follow https://golang.org/doc/install#tarball

Installation
============

Get the code:

	git clone git@github.com:prettygreenplants/prettygreenplants.com.git ~/dev/prettygreenplants

Go into project directory:

	cd ~/dev/prettygreenplants

Check requirements by running the following command and you should get the message `- Everything looks good!`:

	scripts/check_setup.sh

Install project dependencies:

	composer install --prefer-dist --working-dir=neos

Build up docker containers and pull latest version for local development:

	docker-compose pull
	docker-compose build

Check your Linux user account with `echo $UID`. If it does not return 1001, change value in docker-compose.yml to that ID.

Start docker containers:

	docker-compose up -d

Restore content from live to local:

	scripts/syncontent.sh

Update local DNS by editing `/etc/hosts` as root with `sudo vi /etc/hosts` and add the following line:

	0.0.0.0 local.prettygreenplants.com www.local.prettygreenplants.com

Verify:

- Frontend: <https://local.prettygreenplants.com>
- Backend: <https://local.prettygreenplants.com/neos>

Deployment To Live
==================

AWS
---

1. Create an ec2 instances on AWS, associate elastic IP and configure security group
2. Update the system with:

```bash
sudo apt-get update
sudo apt-get upgrade
```

3. Install necessary packages on the cloud (needed for first install only)

```bash
scripts/server_setup.sh
```

4. Get the latest code to AWS, install dependencies and start up containers

```bash
scripts/integrate.sh
```

Infrastructure
==============

SSL & Redirection
-----------------

SSL certificate is generated from letsencrypt free certificate during deployment and twice a day by cronjob added
automatically by the package. Nginx configuration inside web docker container allow `acme-challenge` with http for ssl
validation and generation, and redirect the rest of http request (with or without www) to https://prettygreenplants.com
(without www). Requesting https site with www will also redirect to the non-www version of the site.

For local docker setup, self-signed certificate will be used.

Plugins
=======

Fronted Login
-------------

Plugin installed but not yet configured - TODO

Email Encryption
----------------

All email addresses added as content through editor will be encrypted to prevent spam using the package
`Networkteam.Neos.MailObfuscator`

Google Analytics
----------------

Using package `TYPO3.Neos.GoogleAnalytics` to enable statistics in Google and also in Neos Backend.

- On Google: The tracking id is set in Ansible template and provision the setting to live server. The result can be
found [here](https://analytics.google.com/analytics/web/#report/defaultid/a42523446w121589281p127214097/)
- Inside Neos: The Google Developers Console is configured according to the [doc](http://neos-google-analytics-integration.readthedocs.io/en/stable/)
and the authentication setting with profile id is configured in Ansible template then provision to live server.
The web console can be found [here](https://console.developers.google.com/apis/credentials?project=pretty-green-plants)

TYPO3.Neos.Seo
--------------

The meta keywords and description is set in the inspector of the root page. Current keywords are `plants, tree, garden,
shop, green, pretty, phnom penh, cambodia, pretty, environment, fresh, free delivery` and the description is
`The best plant shop in Phnom Penh selling all kinds of plants, indoor and outdoor, for decorating your home and office
with free delivery service.`.

The title tag is set in the inspector of the page, the field `Title Override`.

Some other meta data are hard-coded directly in the fluid page template.

HTML Output Compressor
----------------------

Using package `Flownative.Neos.Compressor` with default setting to minify html for better site grade.

Content Types and Customization
===============================

Backend Login Wallpaper
-----------------------

Overwrite the default wall paper in the site setting.

Main Menu
---------

Render as TypoScript object `parts.mainMenu` and visibility is enabled in the global setting for beta period.
The default is off, that means no menu displayed.

Social Media
------------

Render as TS object `parts.socialMedia` and read value from site setting.
