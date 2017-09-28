cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p var-www/moodle
    orig_cmd_create \
        --mount type=bind,src=$(pwd)/var-www,dst=/var/www \
        --workdir /var/www/moodle \
        --env php='sudo --user=www-data php' \
        --env moosh='sudo --user=www-data --set-home moosh --no-user-check' \
        --env mysql='mysql --defaults-file=/etc/mysql/debian.cnf' \
        "$@"
}
