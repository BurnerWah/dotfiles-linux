complete -c unlzma -w unxz
complete -c unlzma -x -a "(
    __fish_complete_suffix .lzma
    __fish_complete_suffix .tlz
)"
