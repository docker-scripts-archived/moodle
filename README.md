moodle
======

Docker scripts that install and run Moodle in a container.

## Install

  - First install `ds` and `wsproxy`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation

  - Then get the moodle scripts from github: `ds pull moodle`

  - Create a directory for the moodle container: `ds init moodle @moodle1-example-org`

  - Fix the settings:
    ```
    cd /var/ds/moodle1-example-org/
    vim settings.sh
    ds info
    ```

  - Create the container and install Moodle: `ds make`

    *Note:* This will pull the image from DockerHub. To build the
    image yourself use `ds build` first, however this is usually
    slower.


## Access the website

If the domain is a real one, tell `wsproxy` to get a free
letsencrypt.org SSL certificate for it:
```
ds wsproxy ssl-cert --test
ds wsproxy ssl-cert
```

If the domain is not a real one, add to `/etc/hosts` the line
`127.0.0.1 moodle1.example.org`

Now you can access the website at: https://moodle1.example.org


## Other commands

```
ds shell
ds stop
ds start
ds help
```

## Backup and restore

```
ds backup
ds backup +data
ds restore backup-file.tgz
```

## Clone

```
ds clone tag
ds clone-del tag
```

Cloning will create a new installation inside the same container. It
will copy `/var/www/moodle` to `/var/www/moodle_tag`, `moodledata` to
`moodledata_tag`, `dbname` to `dbname_tag`, etc. and make sure that
the new installation can be accessed on
https://tag.moodle1.example.org


## Update and upgrade

To update the current stable branch (for example from 3.3.1 to 3.3.2)
use `ds update`. This is done quite frequently and usually has no
risks of breaking anything.

To upgrade to the next stable branch (for example from 3.2 to 3.3) use
`ds upgrade moodle MOODLE_33_STABLE`. It will try to upgrade the
additional plugins as well, if they have a version that matches the
latest moodle release. However this does not always work and some
plugins may need to be fixed manually.

Since the upgrade process may be faced with some problems to be solved,
it is better to try it first on a test site, and after making sure that
everything works correctly, apply it to the real site. This can be done
like this:
```
ds clone test
ds upgrade moodle_test MOODLE_33_STABLE

# make sure that everything works and fix any problems

ds upgrade moodle MOODLE_33_STABLE
ds clone-del test
```

Both update and upgrade make a backup before making any changes, just
in case.


## Remake

The command `ds remake` rebuilds everything from scratch, but
preserves the existing database and data files.
