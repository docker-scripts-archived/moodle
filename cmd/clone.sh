cmd_clone_help() {
    cat <<_EOF
    clone <tag>
        Make a clone from 'moodle' to 'moodle_<tag>'.
        <tag> can be something like 'dev', 'test', '01', etc.

_EOF
}

cmd_clone() {
    local tag=$1
    [[ -n $tag ]] || fail "Usage:\n $(cmd_clone_help)"

    if [[ -d var-www/moodle_$tag ]]; then
        echo "The clone 'moodle_$tag' already exists."
        echo "Delete it first with: ds clone-del $tag"
        exit 1
    fi

    # clone the site
    ds runcfg dev/clone $tag

    # add the new domain to wsproxy
    ds @wsproxy domains-add $CONTAINER $tag.$DOMAIN

    # add a new line on /etc/hosts @wsproxy
    local ip=$(ds exec hostname --ip-address)
    ds @wsproxy exec sh -c "echo '$ip $tag.$DOMAIN' >> /etc/hosts"
}
