function ping
    set -l cmd ping
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
