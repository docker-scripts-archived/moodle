cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    # run standard config scripts
    ds runcfg set_prompt
    ds runcfg mount_tmp_on_ram
    ds runcfg ssmtp
    ds runcfg mysql
    ds runcfg apache2

    # run moodle config script
    ds runcfg moodle
}
