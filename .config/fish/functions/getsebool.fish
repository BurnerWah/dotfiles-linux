function getsebool
    set -l cmd getsebool
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
