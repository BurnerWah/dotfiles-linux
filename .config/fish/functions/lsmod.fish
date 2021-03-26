function lsmod
    set -l cmd lsmod
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
