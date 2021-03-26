# free(1) completion
# target version: procps-ng 3.3.15

set -l msg_disp_mem "Display the amount of memory in"

# block completion of files
complete -c free -f

complete -c free -s b -l bytes -d "$msg_disp_mem bytes"
complete -c free -l kilo -d "$msg_disp_mem kilobytes"
complete -c free -l mega -d "$msg_disp_mem megabytes"
complete -c free -l giga -d "$msg_disp_mem gigabytes"
complete -c free -l tera -d "$msg_disp_mem terabytes"
complete -c free -l peta -d "$msg_disp_mem petabytes"
complete -c free -s k -l kibi -d "$msg_disp_mem kibibytes (default)"
complete -c free -s m -l mebi -d "$msg_disp_mem mebibytes"
complete -c free -s g -l gibi -d "$msg_disp_mem gibibytes"
complete -c free -l tebi -d "$msg_disp_mem tebibytes"
complete -c free -l pebi -d "$msg_disp_mem pebibytes"

complete -c free -s h -l human -d "Show human-readable output"
complete -c free -l si -d "Use powers of 1000 not 1024"

complete -c free -s l -l lohi -d "Show detailed low and high memory statistics."
complete -c free -s t -l total -d "Display a line showing the column totals."

complete -c free -x -s s -l seconds -d "Repeat printing every N seconds"
complete -c free -x -s c -l count -d "Repeat printing N times, then exit" -n "__fish_contains_opt -s s seconds"

complete -c free -s w -l wide -d "Switch to the wide mode"

complete -c free -l help -d "Print help"
complete -c free -s V -l version -d "Print version information"
