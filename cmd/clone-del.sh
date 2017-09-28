cmd_clone-del_help() {
    cat <<_EOF
    clone-del <tag>
        Delete clone 'moodle_<tag>'.

_EOF
}

cmd_clone-del() {
    local tag=$1
    [[ -n $tag ]] || fail "Usage:\n$(cmd_clone-del_help)"

    ds @wsproxy domains-rm $tag.$DOMAIN

    ds @wsproxy exec sh -c "
        cp /etc/hosts /etc/hosts.1 ;
        sed -i /etc/hosts.1 -e '/$tag.$DOMAIN/d' ;
        cat /etc/hosts.1 > /etc/hosts;
        rm -f /etc/hosts.1"

    ds runcfg dev/clone-del $tag
}
