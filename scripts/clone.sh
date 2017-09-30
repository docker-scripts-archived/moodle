#!/bin/bash -x
### make a clone of the main moodle site

tag=$1
[[ -z $tag ]] && echo "Usage: $0 <tag>" && exit 1

source /host/settings.sh
moodle="moodle_$tag"
data="data_$tag"
dbname="${DBNAME}_$tag"
domain="$tag.$DOMAIN"
[[ -d /var/www/$moodle ]] && echo "Clone '$moodle' already exists." && exit 1

### clone the data
rm -rf /host/$data
cp -a /host/data /host/$data

### clone the code
rm -rf /var/www/$moodle
cp -a  /var/www/moodle /var/www/$moodle

# fix moodle config file
sed -i /var/www/$moodle/config.php \
    -e "/^\$CFG->dbname/ c \$CFG->dbname    = '$dbname';" \
    -e "/^\$CFG->wwwroot/ c \$CFG->wwwroot   = 'https://$domain';" \
    -e "/^\$CFG->dataroot/ c \$CFG->dataroot  = '/host/$data';"

### create a new database
mysql -e "
        DROP DATABASE IF EXISTS $dbname;
        CREATE DATABASE $dbname;
        GRANT ALL ON $dbname.* TO $DBUSER@localhost;
    "
# copy the data of the database
mysqldump --allow-keywords --opt $DBNAME | mysql --database=$dbname

# replace the old domain with the new one in the database
cd /var/www/$moodle
$php admin/tool/replace/cli/replace.php --search="$DOMAIN" --replace="$domain"

# clear the cache
cd /var/www/$moodle
$php admin/cli/purge_caches.php

# copy and modify the configuration of apache2
find -L -samefile /etc/apache2/sites-available/$moodle.conf | xargs rm -f
cp /etc/apache2/sites-available/{default,$moodle}.conf
sed -i /etc/apache2/sites-available/$moodle.conf \
    -e "s#ServerName .*#ServerName $domain#" \
    -e "s#RedirectPermanent .*#RedirectPermanent / https://$domain/#" \
    -e "s#/var/www/moodle#/var/www/$moodle#g"
ln /etc/apache2/sites-available/{$moodle,$domain}.conf
a2ensite $moodle
cd -

# restart apache2
service apache2 restart
