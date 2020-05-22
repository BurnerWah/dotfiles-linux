# vmstat(8) completion
# target version: procps-ng 3.3.15

complete -c vmstat -x

complete -c vmstat    -s a -l active     -d "Active/inactive memory"
complete -c vmstat    -s f -l forks      -d "Number of forks since boot"
complete -c vmstat    -s m -l slabs      -d "Displays slabinfo"
complete -c vmstat    -s n -l one-header -d "Do not redisplay header"
complete -c vmstat    -s s -l stats      -d "Event counter statistics"
complete -c vmstat    -s d -l disk       -d "Disk statistics"
complete -c vmstat    -s D -l disk-sum   -d "Summarize disk statistics"
complete -c vmstat -x -s p -l partition  -d "Detailed statistics about partition"
# NOTE requires 2.5.70+
# TODO add device arg (should return partitions, might be able to get from /dev)
complete -c vmstat -x -s S -l unit       -d "Define display unit" -a "k\t'Kilobytes (1000)'
                                                                      K\t'Kibibytes (1024)'
                                                                      m\t'Megabytes (1000000)'
                                                                      M\t'Mebibytes (1048576)'"
complete -c vmstat    -s w -l wide       -d "Wide output mode"
complete -c vmstat    -s t -l timestamp  -d "Append timestamp to each line"
complete -c vmstat    -s V -l version    -d "Display version information and exit"
complete -c vmstat    -s h -l help       -d "Display help and exit"
