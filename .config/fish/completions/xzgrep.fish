complete -c xzgrep -w grep
complete -c xzgrep -xa "(
    __fish_complete_suffix .xz
    __fish_complete_suffix .txz
    __fish_complete_suffix .lzma
    __fish_complete_suffix .tlz
)"
