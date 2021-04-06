# Glow completions
# FIXME make file completion case insensitive

set -l subcmd __fish_use_subcommand
set -l seen __fish_seen_subcommand_from
set -l T_help "$seen help && ! $seen config stash && [ (count (commandline -poc | string match help)) -lt 2 ]"

complete -c glow -n "$seen config help" -x
complete -c glow -n "! $seen config help" -x -a "(
    __fish_complete_suffix .md
    __fish_complete_suffix .mkd
    __fish_complete_suffix .mdown
    __fish_complete_suffix .markdown
)"

complete -c glow -s h -l help -d Help
complete -Fc glow -l config -d "Config file"

complete -c glow -n "$subcmd" -s a -l all -d "Show system files and directories"
complete -c glow -n "$subcmd" -s l -l local -d "Show local files only; no network"
complete -c glow -n "$subcmd" -s p -l pager -d "Display with pager"
complete -xc glow -n "$subcmd" -s s -l style -d "Style name or JSON path" -a "auto dark light (__fish_complete_suffix .json)"
complete -c glow -n "$subcmd" -s v -l version -d "Version for glow"
complete -xc glow -n "$subcmd" -s w -l width -d "Word-wrap at width"

set -l M_cmd_config "Edit the glow config file"
set -l M_cmd_help "Help about any command"
set -l M_cmd_stash "Stash a markdown"

complete -c glow -n "$subcmd" -a config -d "$M_cmd_config"
complete -c glow -n "$subcmd" -a help -d "$M_cmd_help"
complete -c glow -n "$subcmd" -a stash -d "$M_cmd_stash"
complete -c glow -n "$T_help" -a config -d "$M_cmd_config"
complete -c glow -n "$T_help" -a help -d "$M_cmd_help"
complete -c glow -n "$T_help" -a stash -d "$M_cmd_stash"

complete -xc glow -n "$seen stash && ! $seen help" -s m -l memo -d "Memo/note for stashing"
