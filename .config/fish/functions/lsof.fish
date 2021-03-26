function lsof
    set -l cmd lsof
    if isatty stdout
        set -p argv +c 0
        # Shows full command names
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
