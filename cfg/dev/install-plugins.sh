#!/bin/bash
### Install the plugins given as arguments.

source /host/settings.sh

plugins="$@"
[[ -z $plugins ]] && echo "No plugins to install" && exit

moodle_version=$(echo $MOODLE_BRANCH | cut -d_ -f2)
for plugin in $plugins; do
    latest_version=$($moosh plugin-list -v | grep $plugin | tr , "\n" | sed '/https/d' | tail -1)
    support=$($moosh plugin-list | grep $plugin | tr , "\n" | sed '/https/d' | tr -d . | grep $moodle_version)
    if [[ -n $support ]]; then
        # install the latest version of the plugin
        $moosh plugin-install -d -f $plugin $latest_version
    else
        echo "Plugin '$plugin' does not support yet $MOODLE_BRANCH."
        echo "If you know what you are doing, you can install it anyway"
        echo "manually with the command:"
        echo "    ds exec sh -c '\$moosh plugin-install -d -f $plugin $latest_version'"
        echo
    fi
done

### update the database
$php admin/cli/upgrade.php --non-interactive
$php admin/cli/purge_caches.php
