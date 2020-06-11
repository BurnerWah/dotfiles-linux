# sd 0.6.5 completions
# TODO prevent first two arguments from being files

complete -xc sd -s f -l flags       -d "Regex flags" -a "c\tCase-sensitive i\tCase-insensitive m\tMulti-line w\t'Full words only'"
complete -c  sd -s h -l help        -d "Prints help information"
complete -c  sd -s s -l string-mode -d "Treat expressions as non-regex strings"
complete -c  sd -s p -l preview
complete -c  sd -s V -l version     -d "Prints version information"
