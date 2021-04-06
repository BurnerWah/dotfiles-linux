complete -c xzdec -xa "(
    __fish_complete_suffix .xz
    __fish_complete_suffix .txz
)"
complete -c xzdec -s h -l help -d "Display help & exit"
complete -c xzdec -s V -l version -d "Display version & exit"
complete -c xzdec -s q -l quiet -d "Use twice to suppress errors"
