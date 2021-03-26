# diskus(1)
complete -xc diskus -s j -l threads -d "Set the number of threads (default: 3 x num cores)"
complete -xc diskus -l size-format -d "Output format for file sizes" -a "decimal\t'MB (default)' binary\tMiB"
complete -c diskus -s v -l verbose -d "Don't hide filesystem errors"
complete -c diskus -s b -l apparent-size -d "Compute apparent size instead of disk usage"
complete -c diskus -s h -l help -d "Prints help information"
complete -c diskus -s V -l version -d "Prints version information"
