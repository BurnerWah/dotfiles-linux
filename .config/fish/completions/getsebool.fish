# getsebool(8) completion
# target version: libselinux-utils 3.0
complete -c getsebool -x -a "(__fish_print_selinux_booleans)"
complete -c getsebool -s a -d "Show all SELinux booleans"
