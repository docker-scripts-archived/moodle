cmd_restore_help() {
    cat <<_EOF
    restore <backup-file.tgz>
        Restore Moodle from the given backup file.

_EOF
}

cmd_restore() {
    # get the backup file
    local file=$1
    test -f "$file" || fail "Usage: $COMMAND <backup-file.tgz>"
    local dir=${file%%.tgz}
    [[ $file != $dir ]] || fail "Usage: $COMMAND <backup-file.tgz>"

    # extract the backup archive
    tar --extract --gunzip --preserve-permissions --file=$file
    dir=$(basename $dir)

    # stop the web server
    ds exec service apache2 stop

    # restore the data/ directory
    if [[ -d $dir/data/ ]]; then
        [[ -d data ]] && mv data data-bak
        cp -a $dir/data/ .
    fi

    # restore the config file
    cp $dir/config.php var-www/moodle/

    # restore the database
    ds exec sh -c "mysql --database='$DBNAME' < /host/$dir/db.sql"

    # cleanup
    rm -rf $dir/

    # start the web server
    ds exec service apache2 start

    # restart the container
    ds restart
}
