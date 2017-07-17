docker-moodle
=============

A Dockerfile that installs and runs Moodle stable 3.1.

## Installation

  - Get scripts from GitHub:
    ```
    mkdir -p /opt/src/
    cd /opt/src/
    git clone https://github.com/docker-build/moodle
    ```

  - Create a working directory for the container:
    ```
    mkdir -p /opt/workdir/moodle1
    cd /opt/workdir/moodle1/
    ln -s /opt/src/moodle .
    cp moodle/utils/settings.sh .
    vim settings.sh
    ```

  - Build image, create the container, start it and configure it:
    ```
    moodle/docker/build.sh
    moodle/docker/create.sh
    moodle/docker/start.sh
    moodle/config.sh
    ```

  - If the domain is not a real one, add to `/etc/hosts` the line
    `127.0.0.1 moodle.example.org` and then try
    http://moodle.example.org in browser.
