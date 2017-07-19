moodle
======

Docker scripts that install and run Moodle in a container.

## Installation

  - First install `ds` and `wsproxy`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation

  - Then get the moodle scripts from github:
    ```
    git clone https://github.com/docker-scripts/moodle /usr/local/src/moodle
    ```

  - Create a working directory for the moodle container:
    ```
    mkdir -p /var/containers/moodle1
    cd /var/containers/moodle1/
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

  - Tell `wsproxy` that the domain `moodle.example.org` is served by the container `moodle1`:
    ```
    cd /var/container/wsproxy/
    ds domains-add moodle1 moodle.example.org
    ds reload
    ```

  - If the domain is not a real one, add to `/etc/hosts` the line
    `127.0.0.1 moodle.example.org` and then try
    https://moodle.example.org in browser.


## Usage

  - Other DS commands:
    ```
    ds shell
    ds stop
    ds start
    ds snapshot
    ds backup
    ```
