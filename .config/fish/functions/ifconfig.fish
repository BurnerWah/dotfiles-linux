function ifconfig
    set -l cmd ifconfig
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
