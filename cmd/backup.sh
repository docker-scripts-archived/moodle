# Backup the moodle database and the config file.

cmd_backup_help() {
    echo "
    backup
        Backup the Moodle database and config file."
}

cmd_backup() {
    datestamp=$(date +%F)
    dir=backup-$CONTAINER-$datestamp
    rm -rf $dir/
    mkdir -p $dir/

    ### dump the database
    docker exec -it $CONTAINER \
        mysqldump --allow-keywords --opt \
        --user="$DBUSER" --password="$DBPASS" "$DBNAME" \
        > $dir/db.sql

    ### copy the config file
    docker cp $CONTAINER:/var/www/moodle/config.php $dir/

    tar cfz $dir.tgz $dir/
    rm -rf $dir/
}
