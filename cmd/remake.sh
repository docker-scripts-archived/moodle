cmd_remake_help() {
    cat <<_EOF
    remake
        Reconstruct again the container, preserving the existing data.

_EOF
}

cmd_remake() {
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
