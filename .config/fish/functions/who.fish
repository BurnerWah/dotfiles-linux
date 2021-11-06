function who
    set -l cmd who
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
