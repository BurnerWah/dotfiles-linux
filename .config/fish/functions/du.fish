function du
    set -l cmd du
    if isatty stdout
        set -p argv --human-readable --si
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
