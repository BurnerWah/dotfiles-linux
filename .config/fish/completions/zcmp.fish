complete -c zcmp -w cmp
complete -c zcmp -xa "(
    __fish_complete_suffix .gz
    __fish_complete_suffix .tgz
)"
