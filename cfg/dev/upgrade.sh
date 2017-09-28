#!/bin/bash -x
### Upgrade moodle version, for example from 3.2 to 3.3

fail() { echo -n "$@" >&2 ; exit 1; }

source /host/settings.sh

### get the target directory to be upgraded
target=$1
[[ -n $target ]] || fail "Usage: $0 <target> <branch>"
[[ -d  /var/www/$target ]] || fail "Directory  /var/www/$target does not exist."

### get the branch to upgrade to (something like MOODLE_33_STABLE)
branch=$2
[[ -n $branch ]] || fail "Usage: $0 <target> <branch>"
[[ $branch == $MOODLE_BRANCH ]] || fail "MOODLE_BRANCH on 'settings.sh' is different from $branch."

### go to the target directory
cd /var/www/$target

### run cron, enable maintenance mode and purge caches
$php admin/cli/cron.php | grep 'task failed:'
$php admin/cli/maintenance.php --enable
$php admin/cli/purge_caches.php

### update moodle code with 'git pull'
git stash
git fetch
git checkout $branch
git pull
git stash pop

### update plugins
moodle_version=$(echo $branch | cut -d_ -f2)
for file in $(git ls-files -o | grep version.php); do
    release=$(cat $file | grep '\->release' | cut -d= -f2 | tr -d " ';")
    [[ -z $release ]] && continue
    plugin=$(cat $file | grep '\->component' | cut -d= -f2 | tr -d " ';")
    latest_version=$($moosh plugin-list -v | grep $plugin | tr , "\n" | sed '/https/d' | tail -1)
    support=$($moosh plugin-list | grep $plugin | tr , "\n" | sed '/https/d' | tr -d . | grep $moodle_version)
    if [[ -n $support ]]; then
        # install the latest version of the plugin
        $moosh plugin-install -d -f $plugin $latest_version
    else
        echo "Plugin '$plugin' does not support yet the latest version of moodle ($release)."
        read -p "Keep it anyway? [y/N]: " ans
        ans=${ans:-n}
        ans=${ans,}
        if [[ $ans == 'y' ]]; then
            $moosh plugin-install -d -f $plugin $latest_version
        else
            rm -rf $(dirname $file)
            echo "Plugin directory $(dirname $file) was removed."
            echo "Try to add it manually later."
        fi
    fi
done

### fix ownership
chown www-data: -R .

### update the database
$php admin/cli/upgrade.php --non-interactive

### purge caches, disable maintenance mode and run cron
$php admin/cli/purge_caches.php
$php admin/cli/maintenance.php --disable
$php admin/cli/cron.php | grep 'task failed:'
