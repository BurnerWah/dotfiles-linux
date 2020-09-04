complete -c printenv -fa "(set -x | string replace ' ' \t'Variable: ')"
complete -c printenv -s 0 -l null -d "End each output line with NUL, not newline"
complete -c printenv -l help -d "Display help & exit"
complete -c printenv -l version -d "Display version & exit"
