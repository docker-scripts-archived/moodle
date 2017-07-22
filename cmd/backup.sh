cmd_backup_help() {
    cat <<_EOF
    backup
        Backup the Moodle database and config file.

_EOF
}

cmd_backup() {
    local datestamp=$(date +%F)
    local dir=backup-$CONTAINER-$datestamp
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
