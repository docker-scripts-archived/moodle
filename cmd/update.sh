cmd_update_help() {
    cat <<_EOF
    update
        Update Moodle.

_EOF
}

cmd_update() {
    local php='ds exec sudo --user=www-data php'
    local git='ds exec sudo --user=www-data git'

    output() { echo -e "\n--> $1..."; }

    output 'Enable maintenance mode'
    $php admin/cli/maintenance.php --enable

    output 'Run cron'
    $php admin/cli/cron.php | grep 'task failed:'

    output 'Purge caches'
    $php admin/cli/purge_caches.php

    output 'Make a full backup'
    ds backup +data
    ls -l backup*

    local ans
    read -p "Continue with update? [Y/n]: " ans
    ans=${ans:-y}
    ans=${ans,}
    if [[ $ans == 'y' ]]; then
        output 'Git pull'
        $git stash
        $git pull
        $git stash pop
        $git diff

        output 'Run upgrade script'
        $php admin/cli/upgrade.php --non-interactive

        output 'Purge caches'
        $php admin/cli/purge_caches.php

        output 'Run cron'
        $php admin/cli/cron.php | grep 'task failed:'
    else
        echo "Update aborted."
    fi

    output 'Disable maintenance mode'
    $php admin/cli/maintenance.php --disable
}
