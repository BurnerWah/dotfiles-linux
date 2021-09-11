# WezTerm completions
set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand
set -l words '(count (commandline -poc))'
set -l cmdline 'commandline -poc'
set -l seq contains_seq
set -l is_subcmd "$needs_subcmd || $seen help && [ $words -lt 3 ]"
set -l using "! $seen help && $seen"

function _wezterm_panes
    command wezterm cli list 2>/dev/null | string match -aer '^\s*\d+' | string replace -r '^\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+x\d+)\s*(.*)$' '$3\t$5'
end

complete -c wezterm -n "$needs_subcmd" -s h -l help -d "Prints help information"
complete -c wezterm -n "$needs_subcmd" -s V -l version -d "Prints version information"
complete -c wezterm -n "$needs_subcmd" -s n -d "Skip loading wezterm.lua"

complete -xc wezterm -n "$is_subcmd" -a cli -d "Interact with experimental mux server"
complete -xc wezterm -n "$is_subcmd" -a connect -d "Connect to wezterm multiplexer"
complete -xc wezterm -n "$is_subcmd" -a help -d "Prints this message or the help of the given subcommand(s)"
complete -xc wezterm -n "$is_subcmd" -a imgcat -d "Output an image to the terminal"
complete -xc wezterm -n "$is_subcmd" -a serial -d "Open a serial port"
complete -xc wezterm -n "$is_subcmd" -a ssh -d "Establish an ssh session"
complete -xc wezterm -n "$is_subcmd" -a start -d "Start a front-end"

# TODO merge shared flags

# TODO cli subcommand
complete -c wezterm -n "$using cli" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using cli" -s V -l version -d "Prints version information"
complete -c wezterm -n "$using cli" -l no-auto-start -d "Don't automatically start the server"

# TODO add proper check for cli subcommands

# `list`, `proxy`, and `tlscreds` take no arguments
# `help` takes a subcommand name, and has no flags
complete -xc wezterm -n "$using cli" -a help -d "Prints this message or the help of the given subcommand(s)"
complete -xc wezterm -n "$using cli" -a list -d "list windows, tabs and panes"
complete -xc wezterm -n "$using cli" -a proxy -d "start rpc proxy pipe"
complete -xc wezterm -n "$using cli" -a split-pane -d "split the current pane."
complete -xc wezterm -n "$using cli" -a tlscreds -d "obtain tls credentials"

complete -c wezterm -n "$seq cli split-pane -- ($cmdline)" -l horizontal -d "Split horizontally rather than vertically"
complete -xc wezterm -n "$seq cli split-pane -- ($cmdline)" -l cwd -d "Initial CWD" -a "(__fish_complete_directories)"
complete -xc wezterm -n "$seq cli split-pane -- ($cmdline)" -l pane-id -d 'Pane to split (default: $WEZTERM_PANE)' -a "(_wezterm_panes)"

# TODO connect subcommand - <domain-name>, <prog>, --?
complete -c wezterm -n "$using connect" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using connect" -s V -l version -d "Prints version information"
complete -xc wezterm -n "$using connect" -l front-end -a "OpenGL Software"

# TODO imgcat subcommand - <file-name>
complete -c wezterm -n "$using imgcat" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using imgcat" -s V -l version -d "Prints version information"
complete -c wezterm -n "$using imgcat" -l preserve-aspect-ratio -d "Don't respect the aspect ratio"
# These can't be completed effectively since they expect strings
complete -xc wezterm -n "$using imgcat" -l height -d "Specify the display height (default: auto)"
complete -xc wezterm -n "$using imgcat" -l height -d "Specify the display width (default: auto)"

# TODO serial subcommand - <port>
complete -c wezterm -n "$using serial" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using serial" -s V -l version -d "Prints version information"
complete -xc wezterm -n "$using serial" -l front-end -a "OpenGL Software"
complete -xc wezterm -n "$using serial" -l baud -d "Set the baud rate (default: 9600)"

# TODO ssh subcommand - <user-at-host-and-port>, <prog>, --?
complete -c wezterm -n "$using ssh" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using ssh" -s V -l version -d "Prints version information"
complete -xc wezterm -n "$using ssh" -l front-end -a "OpenGL Software"

# TODO start subcommand - <prog>, --
complete -c wezterm -n "$using start" -s h -l help -d "Prints help information"
complete -c wezterm -n "$using start" -s V -l version -d "Prints version information"
complete -c wezterm -n "$using start" -l no-auto-connect -d "Don't connect to domains marked as connect_automatically"
complete -xc wezterm -n "$using start" -l cwd -d "Initial CWD" -a "(__fish_complete_directories)"
complete -xc wezterm -n "$using start" -l font-locator -a "FontConfig FontLoader ConfigDirsOnly"
complete -xc wezterm -n "$using start" -l font-rasterizer -a FreeType
complete -xc wezterm -n "$using start" -l font-shaper -a "Harfbuzz AllSorts"
complete -xc wezterm -n "$using start" -l front-end -a "OpenGL Software"
