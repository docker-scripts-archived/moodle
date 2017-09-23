cmd_install-plugins_help() {
    cat <<_EOF
    install-plugins
        Install Moodle additional plugins.

_EOF
}

cmd_install-plugins() {
    ds runcfg plugin/offlinequiz
    ds runcfg plugin/bigbluebutton
    ds runcfg plugin/coderunner
#    ds runcfg plugin/mathslate
#    ds runcfg plugin/webrtcexperiments

    # cleanup
    ds cc
}
