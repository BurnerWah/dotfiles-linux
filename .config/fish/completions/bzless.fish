# bzless generates broken completions
complete -c bzless -xa "(
    __fish_complete_suffix .bz
    __fish_complete_suffix .bz2
)"
