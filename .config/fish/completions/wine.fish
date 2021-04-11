# wine
# This one isn't all that complicated, but the argument descriptions are a bit
# screwed up in the generated version

complete -c wine -l help -d 'Display this help and exit'
complete -c wine -l version -d 'Output version information and exit'

complete -c wine -xa (_CM_suffixes .exe .exe.so .com .scr .msi)
