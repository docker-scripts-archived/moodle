#!/bin/bash -x
### moodle configuration

source /host/settings.sh

### fix apache2 config
sed -i /etc/apache2/sites-available/default.conf \
    -e 's#/var/www/default#/var/www/moodle#g'
service apache2 reload

### change the configuration of mysql
sed -i /etc/mysql/mysql.conf.d/mysqld.cnf \
    -e '/^### required by moodle/,$ d'
cat <<EOF >> /etc/mysql/mysql.conf.d/mysqld.cnf
### required by moodle
default_storage_engine = innodb
innodb_file_per_table = 1
innodb_file_format = Barracuda
EOF
### restart mysql
service mysql restart

### create the database and user
mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
$mysql -e "
    DROP DATABASE IF EXISTS $DBNAME;
    CREATE DATABASE $DBNAME;
    GRANT ALL ON $DBNAME.* TO $DBUSER@localhost IDENTIFIED BY '$DBPASS';
"

### create a directory for moodle data
mkdir -p /host/data
chown -R www-data /host/data
chmod -R 777 /host/data

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

### set the name of the admin user
mysql="mysql --defaults-file=/etc/mysql/debian.cnf --database=$DBNAME -B"
$mysql -e "UPDATE mdl_user
           SET firstname='$SITE_SHORTNAME', lastname='Admin'
           WHERE username='admin'"

### enable and config oauth2
moosh="moosh -n"
$moosh auth-manage enable oauth2
$moosh auth-manage up oauth2

timestamp=$(date +%s)
$mysql -e "INSERT INTO mdl_oauth2_issuer
(id, timecreated, timemodified, usermodified, name, image, baseurl,
clientid, clientsecret, loginscopes, loginscopesoffline, loginparams,
loginparamsoffline, alloweddomains, scopessupported, enabled, showonloginpage,
sortorder) VALUES
(1, $timestamp, $timestamp, 2, 'Google', 'https://accounts.google.com/favicon.ico',
'http://accounts.google.com/', '$GOOGLE_CLIENT_ID', '$GOOGLE_CLIENT_SECRET',
'openid profile email', 'openid profile email', '', 'access_type=offline&prompt=consent',
'', 'openid email profile', 1, 1, 0);"

$mysql -e "INSERT INTO mdl_oauth2_endpoint
(id, timecreated, timemodified, usermodified, name, url, issuerid)
VALUES
(1, $timestamp, $timestamp, 2, 'discovery_endpoint', 'https://accounts.google.com/.well-known/openid-configuration', 1),
(2, $timestamp, $timestamp, 2, 'authorization_endpoint', 'https://accounts.google.com/o/oauth2/v2/auth', 1),
(3, $timestamp, $timestamp, 2, 'token_endpoint', 'https://www.googleapis.com/oauth2/v4/token', 1),
(4, $timestamp, $timestamp, 2, 'userinfo_endpoint', 'https://www.googleapis.com/oauth2/v3/userinfo', 1),
(5, $timestamp, $timestamp, 2, 'revocation_endpoint', 'https://accounts.google.com/o/oauth2/revoke', 1);"

$mysql -e "INSERT INTO mdl_oauth2_user_field_mapping
(id, timemodified, timecreated, usermodified, issuerid, externalfield, internalfield)
VALUES
(1, $timestamp, $timestamp, 2, 1, 'given_name', 'firstname'),
(2, $timestamp, $timestamp, 2, 1, 'middle_name', 'middlename'),
(3, $timestamp, $timestamp, 2, 1, 'family_name', 'lastname'),
(4, $timestamp, $timestamp, 2, 1, 'email', 'email'),
(5, $timestamp, $timestamp, 2, 1, 'website', 'url'),
(6, $timestamp, $timestamp, 2, 1, 'nickname', 'alternatename'),
(7, $timestamp, $timestamp, 2, 1, 'picture', 'picture'),
(8, $timestamp, $timestamp, 2, 1, 'address', 'address'),
(9, $timestamp, $timestamp, 2, 1, 'phone', 'phone1'),
(10, $timestamp, $timestamp, 2, 1, 'locale', 'lang');"

### set default theme
$moosh config-set theme more

$moosh config-set registerauth email

### set smtp settings
$moosh config-set smtphosts 'smtp.gmail.com:465'
$moosh config-set smtpsecure ssl
$moosh config-set smtpauthtype LOGIN
$moosh config-set smtpuser $GMAIL_ADDRESS
$moosh config-set smtppass "$GMAIL_PASSWD"

### install and config mod_offlinequiz
$moosh plugin-list >/dev/null
$moosh plugin-install -f mod_offlinequiz 2017081100
/usr/bin/php admin/cli/upgrade.php <<< y
$moosh config-set shufflequestions 1 offlinequiz
$moosh config-set shuffleanswers 1 offlinequiz
$moosh config-set logourl "$OFFLINEQUIZ_LOGOURL" offlinequiz

### install mod_bigbluebuttonbn
moosh plugin-install mod_bigbluebuttonbn 2016051917
moosh plugin-install mod_recordingsbn 2016051905

### run moodle cron every 5 minutes
echo "*/5 * * * * root /usr/bin/php /var/www/moodle/admin/cli/cron.php >> /var/log/cron.log 2>&1" > /etc/cron.d/moodle

### clear the cache and fix ownership
$moosh cache-clear
rm -rf /host/data/cache/*
rm -rf /host/data/localcache/*
chown www-data: /host/data/cache/
chown www-data: /host/data/localcache/

