#!/bin/bash -x
### install qtype_coderunner and qbehaviour_adaptive_adapted_for_coderunner

moosh -n plugin-install -d -f qbehaviour_adaptive_adapted_for_coderunner 2017052600
moosh -n plugin-install -d -f qtype_coderunner 2017072800
php admin/cli/upgrade.php <<< y
