# Run configuration scripts inside the container.

cmd_config_help() {
    echo "
    config
        Run configuration scripts inside the container."
}

cmd_config() {
    cmd_start
    sleep 3

    # run standard config scripts
    local config="
        set_prompt
        mount_tmp_on_ram
        ssmtp
        mysql
        apache2
    "
    for cfg in $config; do
        ds runcfg $cfg
    done

    # run moodle config script
    ds runcfg moodle

    cmd_restart
}
