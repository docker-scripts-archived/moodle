# bash completions for the command `ds restore`
_ds_restore() {
    local files_tgz=$(ls $(_ds_container_dir) | grep '\.tgz$')
    COMPREPLY=( $(compgen -W "$files_tgz" -- $1) )
}
