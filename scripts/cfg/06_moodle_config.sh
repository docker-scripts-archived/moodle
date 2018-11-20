#!/bin/bash -x
### moodle configuration

source /host/settings.sh

### set the name of the admin user
mysql --database=$DBNAME -B -e \
          "UPDATE mdl_user
           SET firstname='$SITE_SHORTNAME', lastname='Admin'
           WHERE username='admin'"

$moosh config-set theme more    # set theme
$moosh config-set registerauth email

### set smtp settings
if [[ -n $SMTP_SERVER ]]; then
    $moosh config-set smtphosts $SMTP_SERVER
    $moosh config-set smtpsecure TLS
    $moosh config-set smtpauthtype PLAIN
    $moosh config-set smtpuser ''
    $moosh config-set smtppass ''
elif [[ -n $GMAIL_ADDRESS ]]; then
    $moosh config-set smtphosts 'smtp.gmail.com:465'
    $moosh config-set smtpsecure SSL
    $moosh config-set smtpauthtype LOGIN
    $moosh config-set smtpuser $GMAIL_ADDRESS
    $moosh config-set smtppass "$GMAIL_PASSWD"
fi

# Maximum number of messages sent per SMTP session
# Grouping messages may speed up the sending of emails.
$moosh config-set smtpmaxbulk 50

# Allow users to use both username and email address
# (if unique) for site login.
$moosh config-set authloginviaemail 1

$moosh plugin-list >/dev/null
