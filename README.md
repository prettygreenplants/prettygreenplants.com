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

Verify with `php -v` and if not yet installed or not version 7.0, run:

	sudo apt-get install php7.0-cli

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

	git clone git@github.com:visay/PrettyGreenPlants.git ~/dev/prettygreenplants

Go into project directory:

	cd ~/dev/prettygreenplants

Check requirements by running the following command and you should get the message `- Everything looks good!`:

	bin/check_setup.sh

Install project dependencies:

	composer install --prefer-dist

Build up docker containers for local development:

	docker-compose build

Start docker containers:

	docker-compose up -d

Make sure your user is the owner of everything in document root:

	sudo chown -R ${USER}:${USER} ~/dev/prettygreenplants

Restore content from live to local:

	bin/syncontent

Run the command to make sure you are the owner again:

	sudo chown -R ${USER}:${USER} ~/dev/prettygreenplants

Update local DNS by editing `/etc/hosts` as root with `sudo vi /etc/hosts` and add the following line:

	0.0.0.0 prettygreenplants www.prettygreenplants

Verify:

- Frontend: <http://prettygreenplants>
- Backend: <http://prettygreenplants/neos>

Deployment To Live
==================

Ansible
-------

Verify with `ansible --version` and if it is lower than 2.0 or is not yet installed, run:

	sudo add-apt-repository ppa:ansible/ansible -y
	sudo apt-get update
	sudo apt-get -y --force-yes install ansible

Release
-------

	bin/release.sh

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
found on https://analytics.google.com/analytics/web/#report/defaultid/a42523446w121589281p127214097/
- Inside Neos: The Google Developers Console is configured according to
http://neos-google-analytics-integration.readthedocs.io/en/stable/ and the authentication setting with profile id is
configured in Ansible template then provision to live server. The web console can be found at
https://console.developers.google.com/apis/credentials?project=pretty-green-plants

TYPO3.Neos.Seo
--------------

The meta keywords and description is set in the inspector of the root page. Current keywords are `plants, tree, garden,
shop, green, pretty, phnom penh, cambodia, pretty` and the description is `Pretty Green Plants is the best plant shop in
Phnom Penh selling all kinds plants, indoor and outdoor, for decorating your house or office.`.

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
