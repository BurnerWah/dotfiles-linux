function ps -d "Information about running processes"
    set -l cmd ps
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
