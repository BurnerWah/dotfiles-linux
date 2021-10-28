# Faster, more accurate __fish_print_modules
# Current benchmarks suggest the following:
#
# find's optimization level and fd's jobs have no noticable effect,
# so default settings are adequate for them.
#
# find is marginally faster at searching than fd is.
#
# sed is, like, really slow.
#
# frawk was the closest thing to matching string's or
# ripgrep's speeds, but it's unlikely that it's installed.
#
# My computer crashed several times while trying string replace.
# possibly unrelated tho, or a side-effect of hyperfine.
#
# Most notably, the pipelining itself seems to be the main cause for slow down.
if command -qs rg
    function __fish_print_modules
        find /lib/modules/(uname -r)/{kernel,extra,misc} -type f 2>/dev/null | rg '/.*/|\.ko.*' -r ''
    end
else
    function __fish_print_modules
        find /lib/modules/(uname -r)/{kernel,extra,misc} -type f 2>/dev/null | string replace -ar '/.*/|\.ko.*' ''
    end
end
