moodle
======

Docker scripts that install and run Moodle in a container.

## Installation

  - Install `ds` (docker scripts):
    ```
    git clone https://github.com/docker-scripts/ds /usr/local/src/ds
    cd /usr/local/src/ds/
    make install
    ```

  - Get the moodle scripts from github:
    ```
    git clone https://github.com/docker-scripts/moodle /usr/local/src/moodle

    ```

  - Create a working directory for the moodle container:
    ```
    mkdir -p /var/containers/moodle1
    cd /var/containers/moodle1/
    ```

  - Initialize and fix the settings
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

  - If the domain is not a real one, add to `/etc/hosts` the line
    `127.0.0.1 moodle.example.org` and then try
    http://moodle.example.org in browser.


## Usage

  - Other DS commands:
    ```
    ds shell
    ds stop
    ds start
    ds snapshot
    ds backup
    ```
