#!/bin/bash -x
### install mod_bigbluebuttonbn and mod_recordingsbn

moosh -n plugin-install -d -f mod_bigbluebuttonbn 2016051917
moosh -n plugin-install -d -f mod_recordingsbn 2016051905
php admin/cli/upgrade.php <<< y
