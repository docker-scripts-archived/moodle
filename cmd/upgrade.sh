cmd_upgrade_help() {
    cat <<_EOF
    upgrade <target> <moodle-branch>
        Upgrade moodle version.
        <target> can be 'moodle' (default) or the name
        of a clone like: 'moodle_test', 'moodle_01', etc.
        <moodle-branch> is a git branch like MOODLE_33_STABLE

_EOF
}

cmd_upgrade() {
    local target=$1
    [[ -n $target ]] || fail "Usage:\n$(cmd_upgrade_help)"
    [[ -d  var-www/$target ]] || fail "Directory var-www/$target does not exist."

    local branch=$2
    [[ -n $branch ]] || fail "Usage:\n$(cmd_upgrade_help)"
    [[ $branch == $MOODLE_BRANCH ]] || fail "MOODLE_BRANCH on 'settings.sh' is different from $branch."

    # make a backup
    [[ $target == 'moodle' ]] && ds backup +data

    # run upgrade
    ds inject upgrade.sh $target $branch
}
