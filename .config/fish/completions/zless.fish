# zless(1) doesn't generate working completions
complete -c zless -x -a "(__fish_complete_suffix .gz)"
complete -c zless -l help -d "Display help & exit"
complete -c zless -l version -d "Display version & exit"
