cmd_update_help() {
    cat <<_EOF
    update
        Update Moodle.

_EOF
}

cmd_update() {
    local php='ds exec sudo --user=www-data php'
    set -x

    # start maintenance
    $php admin/cli/cron.php > /dev/null
    $php admin/cli/maintenance.php --enable
    $php admin/cli/purge_caches.php

    # make a full backup
    ds backup +data
    ls -l backup*

    # update
    ds exec sudo --user=www-data git pull
    $php admin/cli/upgrade.php --non-interactive

    # stop maintenance
    $php admin/cli/purge_caches.php
    ds exec fgrep '$release' version.php
    $php admin/cli/maintenance.php --disable
}
