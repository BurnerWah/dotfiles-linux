# gapplication(1) completions
# target version: 2.64.2
#
# gapplication(1) doesn't have any switches so we're working word-by-word.
#
# Sometimes we count the number of words that have been typed in the command
# line. While this isn't exactly elegant, and results in some long conditions,
# it's needed to ensure we return the right strings, and to ensure that we only
# return them once.
#
# Currently the biggest limitation is that we can't tell if an application has
# any actions. It's possible with a cache, but that isn't really ideal.
#
# This might still be a little buggy.
#
# TODO add optional PARAMETER arg to action subcommand

set -l prog gapplication
set -l subcmd "__fish_use_subcommand || __fish_seen_subcommand_from help"
set -l words "(count (commandline -poc))"
set -l seen __fish_seen_subcommand_from

function __gapplication_actions -d "Print gapplication actions"
    set -l cmd (commandline -poc)
    command gapplication list-actions $cmd[3]
end

complete -c $prog -n "$subcmd" -x -a help -d "Print help"
complete -c $prog -n "$subcmd" -x -a version -d "Print version"
complete -c $prog -n "$subcmd" -x -a list-apps -d "List applications"
complete -c $prog -n "$subcmd" -x -a launch -d "Launch an application"
complete -c $prog -n "$subcmd" -x -a list-actions -d "List available actions"
complete -c $prog -n "$subcmd" -x -a action -d "Activate an action"

# block completion when not needed
complete -c $prog -x -n "$seen version list-apps"

complete -c $prog -x -n "$seen launch action list-actions && [ $words = 2 ]" \
    -a "(gapplication list-apps)\tApp"

complete -c $prog -x -n "$seen action && [ $words = 3 ]" \
    -a "(__gapplication_actions)\tAction"
