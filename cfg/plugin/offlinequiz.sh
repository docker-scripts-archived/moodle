#!/bin/bash -x
### install and config mod_offlinequiz

moosh -n plugin-install -d -f mod_offlinequiz 2017081100
/usr/bin/php admin/cli/upgrade.php <<< y

source /host/settings.sh
moosh -n config-set shufflequestions 1 offlinequiz
moosh -n config-set shuffleanswers 1 offlinequiz
moosh -n config-set logourl "$OFFLINEQUIZ_LOGOURL" offlinequiz
