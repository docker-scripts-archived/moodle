#!/bin/bash -x
### fix mysql config

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
