# Improved completions for id(1)
set -l has __fish_contains_opt

complete -c id -f -a "(__fish_complete_users)"

complete -c id -s g -l group    -d "Print effective group id" -n "! $has -s g group -s G groups -s u user"
complete -c id -s G -l groups   -d "Print all group ids"      -n "! $has -s g group -s G groups -s u user"
complete -c id -s n -l name     -d "Print name, not number"
complete -c id -s r -l real     -d "Print real ID, not effective"
complete -c id -s u -l user     -d "Print effective user ID"  -n "! $has -s g group -s G groups -s u user"
complete -c id -s h -l help     -d "Display help and exit"
complete -c id -s v -l version  -d "Display version and exit"
