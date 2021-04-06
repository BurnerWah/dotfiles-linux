complete -c lzcat -w xzcat
complete -c lzcat -x -a "(
    __fish_complete_suffix .lzma
    __fish_complete_suffix .tlz
)"
