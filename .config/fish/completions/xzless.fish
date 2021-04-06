complete -c xzless -xa "(
    __fish_complete_suffix .xz
    __fish_complete_suffix .lzma
)"
complete -c xzless -l help -d "Display help & exit"
complete -c xzless -l version -d "Display version & exit"
