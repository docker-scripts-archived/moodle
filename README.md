moodle
======

Docker scripts that install and run Moodle in a container.

## Install

  - First install `ds` and `wsproxy`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation

  - Then get the moodle scripts from github:
    ```
    git clone https://github.com/docker-scripts/moodle /usr/local/src/moodle
    ```

  - Create a working directory for the moodle container:
    ```
    mkdir -p /var/containers/moodle1-example-org
    cd /var/containers/moodle1-example-org/
    ```

  - Initialize and fix the settings:
    ```
    ds init /usr/local/src/moodle
    vim settings.sh
    ds info
    ```

  - Build image, create the container and configure it:
    ```
    ds build
    ds create
    ds config
    ```


## Access the website

  - Tell `wsproxy` that the domain `moodle1.example.org` is served by the container `moodle1-example-org`:
    ```
    cd /var/container/wsproxy/
    ds domains-add moodle1-example-org moodle1.example.org
    ```

  - If the domain is a real one, get a free SSL certificate from letsencrypt.org:
    ```
    ds get-ssl-cert user@example.org moodle1.example.org --test
    ds get-ssl-cert user@example.org moodle1.example.org
    ```

  - If the domain is not a real one, add to `/etc/hosts` the line
    `127.0.0.1 moodle1.example.org` and then try
    https://moodle1.example.org in browser.


## Other commands

```
ds shell
ds stop
ds start
ds snapshot
ds backup

ds help
```
