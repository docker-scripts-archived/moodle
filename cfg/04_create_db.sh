#!/bin/bash -x
### create the database and user

source /host/settings.sh

$mysql -e "
    DROP DATABASE IF EXISTS $DBNAME;
    CREATE DATABASE $DBNAME;
    GRANT ALL ON $DBNAME.* TO $DBUSER@localhost IDENTIFIED BY '$DBPASS';
"
