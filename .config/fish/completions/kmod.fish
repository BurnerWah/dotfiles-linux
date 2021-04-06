# kmod(8) completion
# target version: 27 +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL

set -l seen __fish_seen_subcommand_from
set -l formats \
    "human\t'A human readable format (default)'" \
    "tmpfiles\t'tmpfiles.d(5) format'" \
    "devname\t'modules.devname format'"

complete -c kmod -f

complete -c kmod -s V -l version -d "Show version"
complete -c kmod -s h -l help -d "Show help"

complete -c kmod -x -a help -d "Show help message" -n __fish_use_subcommand
complete -c kmod -x -a list -d "List currently loaded modules" -n "! $seen static-nodes list"
complete -c kmod -x -a static-nodes -d "Outputs the static-node information" -n "! $seen static-nodes list"

complete -c kmod -r -s o -l output -d "Write output to file" -n "$seen static-nodes"
complete -c kmod -x -s f -l format -d "Choose format to use" -n "$seen static-nodes" -a "$formats"

# fish is weird with formatting
