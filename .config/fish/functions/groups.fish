function groups
    if isatty stdout && [ -x /usr/local/libexec/cw/groups ]
        set -lx CW_NORANDOM
        /usr/local/libexec/cw/groups $argv
        return
    end
    command groups $argv
end
