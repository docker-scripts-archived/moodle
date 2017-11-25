cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    # run standard config scripts
    ds inject ubuntu-fixes.sh
    ds inject set_prompt.sh
    ds inject ssmtp.sh
    ds inject mariadb.sh
    ds inject apache2.sh

    # run moodle config scripts
    ds inject cfg/01_mount_tmp_on_ram.sh
    ds inject cfg/02_fix_apache2_config.sh
    ds inject cfg/03_mariadb_config.sh
    ds inject cfg/04_create_db.sh
    ds inject cfg/05_moodle_install.sh
    ds inject cfg/06_moodle_config.sh
    ds inject cfg/07_setup_cron.sh
    ds inject cfg/08_setup_oauth2_google.sh
    ds inject cfg/09_bash_aliases.sh

    # install additional plugins
    ds install-plugins

    # cleanup
    ds cc
}
