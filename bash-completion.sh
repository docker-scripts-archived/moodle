# bash completions for the command `ds restore`
_ds_restore() {
    local cur=${COMP_WORDS[COMP_CWORD]}     ## $1
    if [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -f -X "!*.tgz" -- $cur) )
    fi
}
