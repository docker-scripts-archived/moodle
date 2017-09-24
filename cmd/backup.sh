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

    # stop the web server
    ds exec service apache2 stop

    # create a directory for collecting the backup data
    local datestamp=$(date +%F)
    local dir=backup-$CONTAINER-$datestamp
    rm -rf $dir/
    mkdir -p $dir/

    # dump the database
    ds exec sh -c \
        "mysqldump --defaults-file=/etc/mysql/debian.cnf --allow-keywords --opt '$DBNAME' > /host/$dir/db.sql"

    # copy the config file
    docker cp $CONTAINER:/var/www/moodle/config.php $dir/

    # copy the data directory
    [[ $data == 1 ]] && cp -a data/ $dir/

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$dir.tgz $dir/

    # clean up
    rm -rf $dir/

    # start the web server
    ds exec service apache2 start
}
