cmd_restore_help() {
    cat <<_EOF
    restore <backup-file.tgz>
        Restore Moodle from the given backup file.

_EOF
}

cmd_restore() {
    local file=$1
    test -f "$file" || fail "Usage: $COMMAND <backup-file.tgz>"
    local dir=${file%%.tgz}
    [[ $file != $dir ]] || fail "Usage: $COMMAND <backup-file.tgz>"

    # extract the backup archive
    tar xfz $file
    dir=$(basename $dir)

    # restore the config file
    docker cp $dir/config.php $CONTAINER:/var/www/moodle/

    # restore the database
    sed -i $dir/db.sql -e '/^mysqldump:/d'
    ds exec sh -c \
        "mysql --defaults-file=/etc/mysql/debian.cnf --database="$DBNAME" < /host/$dir/db.sql"

    rm -rf $dir/
}
