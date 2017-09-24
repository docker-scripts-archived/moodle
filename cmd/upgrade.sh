cmd_upgrade_help() {
    cat <<_EOF
    upgrade
        Upgrade to the latest version of Moodle.

_EOF
}

cmd_upgrade() {
    # backup
    ds backup

    # reinstall
    ds remove
    ds build
    ds create
    ds config
    ds restart

    # restore
    local datestamp=$(date +%F)
    local backup_file=backup-$CONTAINER-$datestamp.tgz
    ds restore $backup_file
    sleep 3

    # run upgrade script
    local php='ds exec sudo --user=www-data php'
    $php admin/cli/upgrade.php --non-interactive
}
