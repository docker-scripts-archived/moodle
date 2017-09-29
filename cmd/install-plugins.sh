cmd_install-plugins_help() {
    cat <<_EOF
    install-plugins [<plugin>...]
        Install Moodle additional plugins.
        With no arguments installs the PLUGINS from 'settings.sh'

_EOF
}

cmd_install-plugins() {
    local plugins="$@"
    [[ -n $plugins ]] || plugins="$PLUGINS"
    [[ -n $plugins ]] || fail "Usage:\n$(cmd_install-plugins_help)"

    # install plugins
    ds runcfg dev/install-plugins $plugins

    # config plugins
    ds runcfg plugin/offlinequiz
}
