function netstat -d "Displays network-related information"
    set -l cmd netstat
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
