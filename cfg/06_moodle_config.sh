#!/bin/bash -x
### moodle configuration

source /host/settings.sh

### set the name of the admin user
mysql="mysql --defaults-file=/etc/mysql/debian.cnf --database=$DBNAME -B"
$mysql -e "UPDATE mdl_user
           SET firstname='$SITE_SHORTNAME', lastname='Admin'
           WHERE username='admin'"

moosh="moosh -n"
$moosh config-set theme more    # set theme
$moosh config-set registerauth email

### set smtp settings
$moosh config-set smtphosts 'smtp.gmail.com:465'
$moosh config-set smtpsecure ssl
$moosh config-set smtpauthtype LOGIN
$moosh config-set smtpuser $GMAIL_ADDRESS
$moosh config-set smtppass "$GMAIL_PASSWD"

$moosh plugin-list >/dev/null
