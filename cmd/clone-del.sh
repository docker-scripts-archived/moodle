cmd_clone-del_help() {
    cat <<_EOF
    clone-del <tag>
        Delete clone 'moodle_<tag>'.

_EOF
}

cmd_clone-del() {
    local tag=$1
    [[ -n $tag ]] || fail "\nUsage: $(cmd_clone-del_help)"

    ds @wsproxy domains-rm $tag.$DOMAIN
    ds runcfg dev/clone-del $tag
}
