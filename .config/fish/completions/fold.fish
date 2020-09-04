set -l has __fish_contains_opt

complete -c fold -s b -l bytes -d "Count bytes rather than columns" -n "! $has -s b bytes -s c characters"
complete -c fold -s c -l characters -d "Count characters rather than columns" -n "! $has -s b bytes -s c characters"
complete -c fold -s s -l spaces -d "Break at spaces"
complete -c fold -x -s w -l width -d "Use WIDTH columns instead of 80"
complete -c fold -l help -d "Display help & exit"
complete -c fold -l version -d "Display version & exit"
