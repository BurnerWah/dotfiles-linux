function w
    set -l cmd w
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
