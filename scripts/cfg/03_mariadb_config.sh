#!/bin/bash -x
### fix mariadb config

cat <<EOF > /etc/mysql/conf.d/moodle.cnf
[mysqld]
default_storage_engine = innodb
innodb_file_per_table = 1
innodb_file_format = Barracuda
innodb_large_prefix = ON
binlog_format = ROW
EOF

### restart service
service mysql restart
