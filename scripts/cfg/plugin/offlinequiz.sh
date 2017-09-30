#!/bin/bash -x
### config mod_offlinequiz

$moosh config-set shufflequestions 1 offlinequiz
$moosh config-set shuffleanswers 1 offlinequiz

source /host/settings.sh
$moosh config-set logourl "$OFFLINEQUIZ_LOGOURL" offlinequiz
