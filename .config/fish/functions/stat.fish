function stat
    set -l cmd stat
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
