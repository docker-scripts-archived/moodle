#!/bin/bash -x
### setup cron

### run moodle cron every 5 minutes
echo "*/5 * * * * root /usr/bin/php /var/www/moodle/admin/cli/cron.php >> /var/log/cron.log 2>&1" > /etc/cron.d/moodle
