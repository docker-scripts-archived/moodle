#!/bin/bash -x
### install moodle

source /host/settings.sh

### create a directory for moodle data
mkdir -p /host/data
chown -R www-data /host/data
chmod -R 777 /host/data

### go to the moodle directory
cd /var/www/moodle/

### Get $MOODLE_BRANCH from git.
git pull
git branch --track $MOODLE_BRANCH origin/$MOODLE_BRANCH
git checkout $MOODLE_BRANCH

### set some configuration defaults
cat <<_EOF > local/defaults.php
<?php
\$defaults['moodle']['smtphosts'] = 'smtp.gmail.com:465';
\$defaults['moodle']['smtpsecure'] = 'ssl';
\$defaults['moodle']['smtpauthtype'] = 'LOGIN';
\$defaults['moodle']['smtpuser'] = '$GMAIL_ADDRESS';
\$defaults['moodle']['smtppass'] = '$GMAIL_PASSWD';
_EOF

### install moodle
/usr/bin/php admin/cli/install.php \
    --non-interactive --agree-license \
    --wwwroot="https://$DOMAIN" --dataroot="/host/data" \
    --dbtype="mysqli" --dbname="$DBNAME" --dbuser="$DBUSER" --dbpass="$DBPASS" \
    --lang="$SITE_LANG" --fullname="$SITE_FULLNAME" --shortname="$SITE_SHORTNAME" \
    --adminuser="$ADMIN_USER" --adminpass="$ADMIN_PASS" --adminemail="$ADMIN_EMAIL"

chmod -R 0755 .
