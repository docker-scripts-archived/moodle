#!/bin/bash -x
### install mod_webrtcexperiments

$moosh plugin-install -d -f mod_webrtcexperiments 2017010400
$php admin/cli/upgrade.php --non-interactive
