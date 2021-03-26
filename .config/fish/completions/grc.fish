# grc(1) - The generic colouriser
# TODO add completions for config files

complete -xc grc -a "(__fish_complete_subcommand)"

complete -c grc -l help -d "Show summary of options"
complete -c grc -l version -d "Display version"
complete -c grc -s e -l stderr -d "Redirect error output"
complete -c grc -s s -l stdout -d "Redirect standard output"
complete -c grc -l pty -d "Run command in a pseudoterminal"
complete -xc grc -s c -l config -d "Use a configuration"

complete -c grc -l colour=on -d "Enable colors (default)"
complete -c grc -l colour=off -d "Disable colors"
complete -c grc -l colour=auto -d "Enable colors if output is a TTY"
