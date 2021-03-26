function uptime
    set -l cmd uptime
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
