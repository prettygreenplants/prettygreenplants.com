## Introduction

This is a helper tool for fetch content from Flow Framework / Neos CMS / TYPO3 installation on a remote server to your
local computer running with docker.

## Dependency

This is requires that your Flow Framework / Neos CMS installation is configured to run with `dockerflow` package
(see https://github.com/Sebobo/Shel.DockerFlow) or your TYPO3 installation is configured to run with `dockertypo3`
package (see https://github.com/visay/DockerTYPO3) and all containers are started before executing the sync.

Ansible is needed on your local machine.

## Installation

Add the `syncontent` package into your `composer.json` file and update `composer.lock`. It is recommended to add in the
`require-dev` section of your composer.

```
"visay/syncontent": "dev-master"
```

## Usage

In the root directory of your project, execute:

```bash
bin-dir/syncontent --remote-user=demo-014-007
```

- Replace the user `demo-014-007` with the server username you want to login and get content from
- You need to make sure that you have auto login with public key to `demo-014-007@YOUR_SERVER_HOSTNAME_OR_IP`.
The default host server is `10.10.10.27`, which is my internal web server
- You can define your own server host with `--remote-host=YOUR_SERVER_HOSTNAME_OR_IP` argument
- You can define your own server ssh port with `--remote-port=YOUR_SERVER_SSH_PORT` argument
- You can only run the command from the root directory of your project
- The document root on the server will have to be at `/home/demo-014-007/public_html`
- If you have a different document root path, you can overwrite the default with `--remote-path` argument

So the full overwriting way would be:

```bash
bin-dir/syncontent --remote-user=demo-014-007 --remote-host=10.10.10.37 --remote-port=2222 --remote-path=/home/user/neosbox
```

Or short form of the arguments:

```bash
bin-dir/syncontent -u=demo-014-007 -h=10.10.10.37 -P=2222 -p=/home/user/neosbox
```

### Available arguments

- `-u` | `--remote-user` : Set the login user to the remote server (__Required__)
- `-h` | `--remote-host` : Set the hostname or IP address of the remote server (__Default__: `10.10.10.27`)
- `-P` | `--remote-port` : Set the ssh port of the remote server (__Default__: `22`)
- `-p` | `--remote-path` : Set path to the document root on the remote server (__Default__: `/home/<remote-user>/public_html`)
- `-t` | `--ansible-tags`: Set the specific task you want run. See available sync tasks section for details
- `--remote-php`         : Set the path to php on the remote server
- `--remote-dump`        : Set the sql dump location on the remote server. It must contain the absolute path and filename
- `--from-cache`         : Use local caches of files and database dump from previous run instead of getting fresh from remote
- `-v`                   : Set the verbosity of ansible output. You can also set more verbose by adding more `v` like `-vvvvv`
- `--dry-run`            : Force to display the command to execute but won't run them. Useful for debugging when you want
                           to see the full ansible command and maybe execute them directly for better error hints

### Customization

If you are lazy typing the user again and again, you can define it permanently by creating a file in
`vendor-dir/visay/syncontent/config/master` with the same name as the `--remote-user` value.

```
vendor-dir
└── visay
	└── syncontent
		├── ansible
		├── bin
		├── config
		│   └── master
		│       └── demo-014-007
		├── CHANGELOG
		├── composer.json
		└── README.md
```

You can also overwrite the default value of `--remote-host`, `--remote-port`, `--remote-path`, `--remote-php`, etc, by setting it in the created master file.

```vendor-dir/visay/syncontent/config/master/demo-014-007
--remote-host=10.10.10.37
--remote-port=2222
--remote-path=/home/user/neosbox
--remote-php=/opt/php-versions/php55/bin/php
```

With this file and its content, you can now execute the content sync with just:

```bash
bin-dir/syncontent
```

And the script will automatically take `demo-014-007` as the content master, `10.10.10.37` as server host and
`/home/user/neosbox` as remote path.

- You can also combine that some settings are in config file and some are passed as argument
- If the same config are set in the config and pass as argument, the argument value will take effect
- There should be only one master at a time. That means you should not have more than more file in the `config/master`
directory. In case there are more than one file exists, the script will take first file only to process.
- In most case, the default host and path work fine for internal Web Essentials project development
and you just need to define the `--remote-user`

### Available Sync Tasks

syncontent does its job in 3 different batches. First it sync the user files from remote server to local. Second it dumps
the database from remote and restore on local and last it runs some necessary commands to clean up depends on the framework.

By default, syncontent will run all 3 tasks but you can pass the parameter to call specific task only that you want to run.

```bash
bin-dir/syncontent --ansible-tags=<TASK-NAME>
```

The available task names are:

- rsync
- db
- cleanup

### 1. rsync

The first task is to sync directory content from remote to local. Files that exists only in local will be removed
to make sure everything is exactly the same as on remote.

For Flow, `Data/Persistent/` will be synced while for TYPO3 these directory will be synced:

- Web/fileadmin/
- Web/typo3conf/l10n/
- Web/uploads/

The file/directory with the name `.gitkeep`, `_temp_` and `_processed_` will not be synced.

To execute this task only, run the command:

```bash
bin-dir/syncontent --ansible-tags=rsync
```

### 2. db

The second task is to reset the local database. For Flow Framework, it will start by connecting to remote server and
get the database connection information for the running context. You cannot change to other context at the moment so
if your remote is not running in Production context, this tool won't work for you but anyway tweaking it to work is
not that hard and you can do it in the ansible role.

Once it gets all the information, it will dump the database, zip it and download to local temp. Before restoring to local
database, it first deletes the local database completely and recreate it again. This way assures that we have exact
state as on remote and prevent from any issues with the database content leftover.

For TYPO3, the process is almost the same except that the first step of dumping the database doesn't exist but user
has to defined the location of the dump file on the remote server with the switch `--remote-dump`. That means
the process of creating dump file is manually created. That will change in the future release.

To execute this task only, run this command:

```bash
bin-dir/syncontent --ansible-tags=db
```

For TYPO3, most of the time after restoring data, the domain records need to be adjusted to match your local setup.
In this case, you can provide a list of pair value so that this tool can search and replace it before restoring to your
local system.

To do that, create a file called `main.yml` in `ansible/roles/database/defaults/` directory and add the following content:

```
---
# Content replacement in database
replacement:
  1:
    search: live-domain.com
    replace: local-domain
  2:
    search: live-domain2.net
    replace: domain2.local-domain
```

`replacement`, `search` and `replace` are keyword but for `1` and `2` you can use any strings to define your content type.
Just add more array list with `search` and `replace` pair if needed.

### 3. cleanup

The last step is to run some necessary commands needed by the framework for the application to work.

They run in the following order for Flow Framework:

- flow:cache:flush --force
- database:setcharset
- doctrine:migrate
- resource:publish
- cache:warmup

And for TYPO3 CMS (`helhum/typo3-console` package is required for this part to run):

- cache:flush
- database:updateschema --schema-update-types=field.add
- database:updateschema --schema-update-types=field.change
- database:updateschema --schema-update-types=field.drop
- database:updateschema --schema-update-types=table.add
- database:updateschema --schema-update-types=table.change
- database:updateschema --schema-update-types=table.drop
- database:updateschema --schema-update-types=table.clear
- cleanup:updatereferenceindex
- cache:warmup

To execute this task only, run this command:

```bash
bin-dir/syncontent --ansible-tags=cleanup
```

## Author

Visay Keo <visay@web-essentials.asia>

If you have any feedback, comments and/or questions, feel free to contact with email address above. And of course,
a merge request is always welcomed.
