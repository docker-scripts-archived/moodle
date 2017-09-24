#!/bin/bash -x
### setup aliases

cat <<_EOF > /root/.bash_aliases
alias php='sudo --user=www-data php'
alias moosh='sudo --user=www-data --set-home moosh --no-user-check'
alias mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
_EOF
