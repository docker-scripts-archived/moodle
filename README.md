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

  - Build image, create the container and configure it: `ds make`


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
ds snapshot

ds backup
ds restore
ds upgrade

ds help
```
