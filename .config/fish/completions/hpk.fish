# hpk completion

set -l is_subcmd __fish_use_subcommand
set -l seen __fish_seen_subcommand_from

complete -c hpk -s h -l help -d "Prints help information"
complete -c hpk -s V -l version -d "Prints version information"

complete -c hpk -n "$is_subcmd || $seen help" -xa create -d "Create a new hpk archive"
complete -c hpk -n "$is_subcmd || $seen help" -xa extract -d "Extract files from a hpk archive"
complete -c hpk -n "$is_subcmd || $seen help" -xa list -d "List the content of a hpk archive"
complete -c hpk -n "$is_subcmd || $seen help" -xa print -d "Print information of a hpk archive"
complete -c hpk -n "$is_subcmd" -xa help -d "Prints help for the given subcommand(s)"

complete -c hpk -n "$seen create" -xa "(__fish_complete_directories)"

complete -c hpk -n "$seen create" -l compress -d "Compress the whole hpk file"
complete -c hpk -n "$seen create" -l lz4 -d "Sets LZ4 as encoder"
complete -c hpk -n "$seen create" -l cripple-lua-files -d "Cripple bytecode header for Victor Vran or Surviving Mars"
complete -c hpk -n "$seen create" -l with-filedates -d "Stores the last modification times in a _filedates file"
complete -xc hpk -n "$seen create" -l chunk-size -d "Chunk size (default: 32768)"
complete -xc hpk -n "$seen create" -l extensions -d "File extensions to be compressed"
complete -xc hpk -n "$seen create" -l filedate-fmt -d "Format of the stored filedates" -a "default\t'Windows file time' short\t'Windows file time / 2000'"

complete -c hpk -n "$seen extract list print" -xa "(__fish_complete_suffix .hpk)"

complete -c hpk -n "$seen extract" -l ignore-filedates -d "Skip processing of a _filedates file and just extract it"
complete -c hpk -n "$seen extract" -l fix-lua-files -d "Fix the bytecode header of Victor Vran's or Surviving Mars' Lua files"
complete -c hpk -n "$seen extract" -l force -d "Force extraction if destination folder is not empty"
complete -c hpk -n "$seen extract" -s v -d "Verbosely list files processed"

complete -c hpk -n "$seen print" -l header-only -d "Print only the header informations"
