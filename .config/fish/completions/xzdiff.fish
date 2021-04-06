complete -c xzdiff -w diff
complete -c xzdiff -xa "(
    __fish_complete_suffix .xz
    __fish_complete_suffix .txz
    __fish_complete_suffix .lzma
    __fish_complete_suffix .tlz
)"
