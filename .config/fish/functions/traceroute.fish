function traceroute
    set -l cmd traceroute
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
