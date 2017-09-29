#!/bin/bash -x
### delete a clone of the main moodle site

tag=$1
[[ -z $tag ]] && echo "Usage: $0 <tag>" && exit 1

### delete apache2 config
a2dissite moodle_$tag
find -L -samefile /etc/apache2/sites-available/moodle_$tag.conf | xargs rm -f
service apache2 restart

### remove the code and the data
rm -rf /var/www/moodle_$tag
rm -rf /host/data_$tag

### drop the database
source /host/settings.sh
mysql -e "DROP DATABASE IF EXISTS ${DBNAME}_$tag;"
