#!/bin/bash -x
### Update Moodle.

### go to the moodle directory
target=${1:-moodle}
cd /var/www/$target

### run cron, enable maintenance mode and purge caches
$php admin/cli/cron.php | grep 'task failed:'
$php admin/cli/maintenance.php --enable
$php admin/cli/purge_caches.php

### update moodle code with 'git pull'
git stash
git pull
git stash pop
chown www-data: -R .

### update the database
$php admin/cli/upgrade.php --non-interactive

### purge caches, disable maintenance mode and run cron
$php admin/cli/purge_caches.php
$php admin/cli/maintenance.php --disable
$php admin/cli/cron.php | grep 'task failed:'
