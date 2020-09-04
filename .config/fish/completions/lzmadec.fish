complete -c lzmadec -xa "(
  __fish_complete_suffix .lzma
  __fish_complete_suffix .tlz
)"
complete -c lzmadec -s h -l help -d "Display help & exit"
complete -c lzmadec -s V -l version -d "Display version & exit"
complete -c lzmadec -s q -l quiet -d "Use twice to suppress errors"
