complete -c lzcmp -w cmp
complete -c lzcmp -xa "(
    __fish_complete_suffix .lzma
    __fish_complete_suffix .tlz
)"
