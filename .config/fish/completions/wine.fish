# wine
# This one isn't all that complicated, but the argument descriptions are a bit
# screwed up in the generated version

complete -c wine -l help -d 'Display this help and exit'
complete -c wine -l version -d 'Output version information and exit'

complete -c wine -xa "(
  __fish_complete_suffix .exe
  __fish_complete_suffix .exe.so
  __fish_complete_suffix .com
  __fish_complete_suffix .scr
  __fish_complete_suffix .msi
)"
