set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand

complete -c handlr -s h -l help -d "Prints help information"
complete -c handlr -s v -l version -d "Prints version information"

complete -c handlr -n "$needs_subcmd" -xa list -d "List default apps and the associated handlers"
complete -c handlr -n "$needs_subcmd" -xa open -d "Open a path/URL with its default handler"
complete -c handlr -n "$needs_subcmd" -xa set -d "Set the default handler for mime/extension"
complete -c handlr -n "$needs_subcmd" -xa unset -d "Unset the default handler for mime/extension"
complete -c handlr -n "$needs_subcmd" -xa launch -d "Launch the handler for specified extension/mime with optional arguments"
complete -c handlr -n "$needs_subcmd" -xa get -d "Get handler for this mime/extension"
complete -c handlr -n "$needs_subcmd" -xa add -d "Add a handler for given mime/extension"

complete -c handlr -n "$seen list set unset get add" -f
complete -c handlr -n "$seen set unset launch get add && [ (count (commandline -poc)) = 2 ]" -xa "(__fish_print_xdg_mimetypes)"

complete -c handlr -n "$seen list" -s a -l all -d "Print all"

complete -c handlr -n "$seen get" -l json -d "JSON Output"
