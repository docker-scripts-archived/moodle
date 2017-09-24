cmd_cc_help() {
    cat <<_EOF
    cc
        Clear the cache.

_EOF
}

cmd_cc() {
    local php='ds exec sudo --user=www-data php'
    $php admin/cli/purge_caches.php

    ds exec sh -c "rm -rf /host/data/cache/*"
    ds exec sh -c "rm -rf /host/data/localcache/*"

    ds exec chown www-data: /host/data/cache/
    ds exec chown www-data: /host/data/localcache/
}
