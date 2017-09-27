cmd_update_help() {
    cat <<_EOF
    update [<target>]
        Update Moodle. <target> can be 'moodle' (default) or
        the name of a clone like: 'moodle_test', 'moodle_01', etc.

_EOF
}

cmd_update() {
    local target=${1:-moodle}
    [[ $target == 'moodle' ]] && ds backup +data
    ds runcfg dev/update $target
}
