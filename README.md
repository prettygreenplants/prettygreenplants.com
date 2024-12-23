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

Verify with `php -v` and if not yet installed or not version 8.3, run:

	sudo apt-get install php8.3-cli

php extensions
--------------

Make sure these extensions are installed:

- curl
- xml
- zip

Verify with `php -m` and see if any of them are not in the list, re-install all with:

	sudo apt-get install php8.3-curl php8.3-xml php8.3-zip

composer
--------

You don't need to install composer on your local machine as we will docker image to
help with this task.

docker
------

Verify with `docker -v` and if not yet installed, follow
<https://docs.docker.com/engine/installation/linux/ubuntulinux/>

Additionally, add current Linux user to docker group and restart the machine so
docker can be run as normal user.

docker compose
--------------

Verify with `docker compose version` and if not yet installed, run:

	sudo apt-get install docker-compose-plugin

Refer to <https://docs.docker.com/compose/install/linux/>

Ansible
-------

Verify with `ansible --version` and if it is not version 2.10 or is not yet installed, run:

	sudo add-apt-repository --yes --update ppa:ansible/ansible-2.10
	sudo apt install ansible

Note that from ansible 2.17 up, python version on managed nodes must be 3.0 up too.

Installation
============

Get the code:

	git clone git@github.com:prettygreenplants/prettygreenplants.com.git ~/dev/prettygreenplants

Go into project directory:

	cd ~/dev/prettygreenplants

Check requirements by running the following command and you should get the
message `- Everything looks good!`:

	scripts/check_setup.sh

Install project dependencies:

	docker run --rm --interactive --tty --volume ~/dev/prettygreenplants/neos:/app \
	--user $UID:$UID composer:2.8 install --prefer-dist

Create docker environment file and adjust to match your local setup

	cp env.dev .env

Build up docker containers and pull latest version for local development:

	docker compose pull
	docker compose build

Check your Linux user account with `echo $UID` and update `.env` file to match.

Start docker containers:

	docker compose up -d

Restore content from staging to local:

	FROM_DATE=2024-10-19 scripts/syncontent.sh staging

_Note_: If `FROM_DATE` is not set, then it takes today's date for the backup filename.
Make sure your local environment has `bzip2` installed for the archive extraction:

	sudo apt-get install bzip2

Update local DNS by editing `/etc/hosts` as root with `sudo vi /etc/hosts` and
add the following line:

	0.0.0.0 local.prettygreenplants.com www.local.prettygreenplants.com

Verify:

- Frontend: <https://local.prettygreenplants.com>
- Backend: <https://local.prettygreenplants.com/neos>

Deployment To Live
==================

Staging
-------

1. Manually push docker images to docker.io

```bash
docker login -u visay --password-stdin docker.io
docker tag prettygreenplants-app prettygreenplants/app:latest
docker push prettygreenplants/app:latest
```
2. Get the latest code, install dependencies, pull images and start up containers

```bash
scripts/deploy.sh staging
```

AWS
---

1. Create an ec2 instances on AWS, associate elastic IP and configure security
group to allow SSH, HTTP and HTTPS to the server
2. Update the system with:

```bash
sudo apt-get update
sudo apt-get upgrade
```

3. Generate and update AWS access key ID and secret key in `ansible/group_vars/live/vault.yml`
4. Update `ansible/ssh.cfg` file to apply new IP address
5. Point DNS record to the new IP address
6. Create empty bucket `pgp-website-backup` in AWS S3 for storing backup
7. Manually push docker images to docker.io

```bash
docker login -u visay --password-stdin docker.io
docker tag prettygreenplants_app prettygreenplants/app:latest
docker push prettygreenplants/app:latest
```

8. Install necessary packages on the cloud, get the latest code, install
dependencies and start up containers

```bash
scripts/deploy.sh live
```

Infrastructure
==============

Backup & Restore
----------------

Every night, there is a container containing cronjob which calls the backup script defined in `docker/db-backup/scripts/`
to backup the database to `/var/www/backup/prettygreenplants/db` and another cronjob on docker host to backup files
(`Data/Logs` and `Data/Persistent`) to `/var/www/backup/prettygreenplants/files`.

The backup db file is then used by the syncontent script to fetch from cloud and
restore locally or to setup on a new cloud server. To restore on the new cloud, run:

```bash
docker-compose -f docker-compose-prod.yml run --rm -e FROM_DATE=2021-06-19 db_backup /opt/mysql/restore-database
```

_Note_: If `FROM_DATE` is not set, then it takes today's date for the backup filename.
_Note_: For every reset, always check the google analytic backend module to make
sure the connection is still working. If not, just reconnect and save the setting.

Syncontent script fetch files directly from Neos document root and not taking
from the backup as the db.

The third cronjob is to sync both the file and db backup to Amazon S3 bucket
`prettygreenplants-website-backup` so make sure that bucket is manually created on S3.

The last cronjob is for cleaning up backup files/directories
(both file and db backup) that are older than specified period.
See `rotate.sh.j2` ansible template in `backup` role.

SSL & Redirection
-----------------

SSL certificate is generated from letsencrypt free certificate during deployment
and twice a day by cronjob added automatically by the package. Nginx
configuration inside web docker container allow `acme-challenge` with http for
ssl validation and generation, and redirect the rest of http request
(with or without www) to https://prettygreenplants.com (without www). Requesting
https site with www will also redirect to the non-www version of the site.

For local docker setup, self-signed certificate will be used.

Plugins
=======

Fronted Login
-------------

Plugin installed but not yet configured - TODO

Email Encryption
----------------

All email addresses added as content through editor will be encrypted to prevent
spam using the package `Networkteam.Neos.MailObfuscator`

Google Analytics
----------------

Using package `TYPO3.Neos.GoogleAnalytics` to enable statistics in Google and
also in Neos Backend.

- On Google: The tracking id is set in Ansible template and provision the
setting to live server. The result can be found
[here](https://analytics.google.com/analytics/web/#report/defaultid/a42523446w121589281p127214097/)
- Inside Neos: The Google Developers Console is configured according to the
[doc](http://neos-google-analytics-integration.readthedocs.io/en/stable/) and
the authentication setting with profile id is configured in Ansible template
then provision to live server. The web console can be found
[here](https://console.developers.google.com/apis/credentials?project=pretty-green-plants)

TYPO3.Neos.Seo
--------------

The meta keywords and description is set in the inspector of the root page.
Current keywords are `plants, tree, garden, shop, green, pretty, phnom penh,
cambodia, pretty, environment, fresh, free delivery` and the description is
`The best online plant shop in Phnom Penh selling all kinds of plants, indoor
and outdoor, for decorating your home and office with free delivery service.`.

The title tag is set in the inspector of the page, the field `Title Override`.

Some other meta data are hard-coded directly in the fluid page template.

HTML Output Compressor
----------------------

Using package `Flownative.Neos.Compressor` with default setting to minify html
for better site grade.

Content Types and Customization
===============================

Backend Login Wallpaper
-----------------------

Overwrite the default wall paper in the site setting.

Main Menu
---------

Render as TypoScript object `parts.mainMenu` and visibility is enabled in the
global setting for beta period. The default is off, that means no menu displayed.

Social Media
------------

Render as TS object `parts.socialMedia` and read value from site setting.

Facebook Chat
-------------

Render as TS object `parts.messenger` using snippet from Facebook. This is
rendered in Frontend only so it is not affecting the Backend editing experience.
