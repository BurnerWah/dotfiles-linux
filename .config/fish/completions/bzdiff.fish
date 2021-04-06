complete -c bzdiff -w diff
complete -c bzdiff -xa "(
    __fish_complete_suffix .bz
    __fish_complete_suffix .bz2
    __fish_complete_suffix .tbz
    __fish_complete_suffix .tbz2
)"
