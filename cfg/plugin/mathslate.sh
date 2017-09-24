#!/bin/bash -x
### install atto_mathslate and tinymce_mathslate

$moosh plugin-install -d -f atto_mathslate 2015041602
$moosh plugin-install -d -f tinymce_mathslate 2015041701
$php admin/cli/upgrade.php --non-interactive
