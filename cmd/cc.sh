cmd_cc_help() {
    cat <<_EOF
    cc
        Clear the cache and fix ownership.

_EOF
}

cmd_cc() {
    ds exec moosh -n cache-clear

    ds exec sh -c "rm -rf /host/data/cache/*"
    ds exec sh -c "rm -rf /host/data/localcache/*"

    ds exec chown www-data: /host/data/cache/
    ds exec chown www-data: /host/data/localcache/
}
