cmd_install-plugins_help() {
    cat <<_EOF
    install-plugins
        Install Moodle additional plugins.

_EOF
}

cmd_install-plugins() {
    [[ -n $PLUGINS ]] || return

    for plugin in $PLUGINS; do
        ds runcfg plugin/$plugin
    done

    # cleanup
    ds cc
}
