#!/bin/bash -x
### install moodle

source /host/settings.sh

### create a directory for moodle data
mkdir -p /host/data
chown -R www-data /host/data
chmod -R 777 /host/data

### Get MOODLE_33_STABLE from git.
git clone -b MOODLE_33_STABLE git://git.moodle.org/moodle.git --depth=1 /var/www/moodle

### go to the moodle directory
cd /var/www/moodle/

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
