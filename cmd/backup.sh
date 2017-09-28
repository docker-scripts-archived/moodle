cmd_backup_help() {
    cat <<_EOF
    backup [+d | +data]
        Backup the Moodle database and config file.
        With option +d, the data directory is included in the backup as well.

_EOF
}

cmd_backup() {
    # get the option +data
    local data=0
    [[ $1 == '+d' || $1 == '+data' ]] && data=1

    # clear caches, enable maintenance mode, and stop the web server
    local php='ds exec sudo --user=www-data php'
    $php admin/cli/cron.php | grep 'task failed:'
    $php admin/cli/maintenance.php --enable
    $php admin/cli/purge_caches.php
    ds exec service apache2 start

    # create a directory for collecting the backup data
    local datestamp=$(date +%F)
    local dir=backup-$CONTAINER-$datestamp
    rm -rf $dir/
    mkdir -p $dir/

    # dump the database
    ds exec sh -c \
        "mysqldump --defaults-file=/etc/mysql/debian.cnf --allow-keywords --opt '$DBNAME' > /host/$dir/db.sql"

    # copy the config file
    cp var-www/moodle/config.php $dir/

    # copy the data directory
    [[ $data == 1 ]] && cp -a data/ $dir/

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$dir.tgz $dir/

    # clean up
    rm -rf $dir/

    # start the web server and disable maintenance mode
    ds exec service apache2 start
    $php admin/cli/maintenance.php --disable
}
