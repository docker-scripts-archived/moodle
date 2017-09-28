#!/bin/bash -x
### install and config mod_offlinequiz

$moosh plugin-install -d -f mod_offlinequiz 2017081100
$php admin/cli/upgrade.php --non-interactive

source /host/settings.sh
$moosh config-set shufflequestions 1 offlinequiz
$moosh config-set shuffleanswers 1 offlinequiz
$moosh config-set logourl "$OFFLINEQUIZ_LOGOURL" offlinequiz
