#!/bin/bash -x
### fix apache2 config

sed -i /etc/apache2/sites-available/default.conf \
    -e 's#/var/www/default#/var/www/moodle#g'

service apache2 reload
