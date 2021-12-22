set -l seen __fish_seen_subcommand_from

complete -c systemd-analyze -x
complete -f -c systemd-analzye -s H -l host -d 'Execute the operation on a remote host' -a "(__fish_print_hostnames)"
complete -x -c systemd-analzye -s M -l machine -d 'Execute operation on a VM or container' -a "(__fish_systemd_machines)"
complete -f -c systemd-analzye -s h -l help -d 'Print a short help and exit'
complete -f -c systemd-analzye -l version -d 'Print a short version and exit'
complete -f -c systemd-analzye -l no-pager -d 'Do not pipe output into a pager'
complete -f -c systemd-analzye -l user -d 'Talk to the service manager of the calling user' -n "not __fish_contains_opt system user"
complete -f -c systemd-analzye -l system -d 'Talk to the service manager of the system.' -n "not __fish_contains_opt system user"

set -l commands time blame critical-chain plot dot dump cat-config unit-files unit-paths \
    exit-status capability syscall-filter condition set-log-level set-log-target verify calendar \
    timestamp timespan security

complete -c systemd-analyze -n "! $seen $commands" -a time -d "Print time spent in the kernel" -f
complete -c systemd-analyze -n "! $seen $commands" -a blame -d "Print list of running units ordered by time to init" -f
complete -c systemd-analyze -n "! $seen $commands" -a critical-chain -d "Print a tree of the time critical chain of units" -f
complete -c systemd-analyze -n "! $seen $commands" -a plot -d "Output SVG graphic showing service initialization" -f
complete -c systemd-analyze -n "! $seen $commands" -a dot -d "Output dependency graph in dot(1) format" -f
complete -c systemd-analyze -n "! $seen $commands" -a dump -d "Output state serialization of service manager" -f

complete -c systemd-analyze -n "! $seen $commands" -a cat-config -d "Show configuration file and drop-ins"
complete -c systemd-analyze -n "! $seen $commands" -a unit-files -d "List files and symlinks for units"
complete -c systemd-analyze -n "! $seen $commands" -a unit-paths -d "List load directories for units"
complete -c systemd-analyze -n "! $seen $commands" -a exit-status -d "List exit status definitions"
complete -c systemd-analyze -n "! $seen $commands" -a capability -d "List capability definitions"
complete -c systemd-analyze -n "! $seen $commands" -a syscall-filter -d "Print list of syscalls in seccomp filter"
complete -c systemd-analyze -n "! $seen $commands" -a condition -d "Evaluate conditions and asserts"

# complete -c systemd-analyze -n "! $seen $commands" -a set-log-level -d "Set logging threshold for manager" -f
# complete -c systemd-analyze -n "! $seen $commands" -a set-log-target -d "Set logging target for manager" -f
complete -c systemd-analyze -n "! $seen $commands" -a verify -d "Check unit files for correctness"

complete -c systemd-analyze -n "! $seen $commands" -a calendar -d "Validate repetitive calendar time events"
complete -c systemd-analyze -n "! $seen $commands" -a timestamp -d "Validate a timestamp"
complete -c systemd-analyze -n "! $seen $commands" -a timespan -d "Validate a time span"
complete -c systemd-analyze -n "! $seen $commands" -a security -d "Analyze security of unit"

complete -c systemd-analyze -n "$seen security" -xa "(__fish_systemctl_services)"
