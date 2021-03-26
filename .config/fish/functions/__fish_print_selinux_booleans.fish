# Helper function mostly used by getsebool.fish
# I'd like to make the abstraction a little more useful at some point, but it
# works well enough for now.
function __fish_print_selinux_booleans -d "Print SELinux booleans"
    command getsebool -a \
        | string replace -r '(\S+?)\s+-->\s+(\S+)$' '$1\t$2'
end
