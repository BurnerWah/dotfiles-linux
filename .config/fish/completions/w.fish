# less barebones completions for w(1)
# Also adds support for my wrapper
complete -c w -x -a "(__fish_complete_users)" -d "Username"

complete -c w -s h -l no-header  -d "Dont print header"
complete -c w -s u -l no-current -d "Ignore username for time calculations"
complete -c w -s s -l short      -d "Short format"
complete -c w -s f -l from       -d "Toggle printing of remote hostname"
complete -c w      -l help       -d "Display help and exit"
complete -c w -s i -l ip-addr    -d "Display IP address instead of hostname" -n "__fish_contains_opt -s f from"
complete -c w -s V -l version    -d "Display version and exit"
complete -c w -s o -l old-style  -d "Old output style"
complete -c w -s J -l json       -d "Use JSON output format"
