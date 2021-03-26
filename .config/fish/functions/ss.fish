function ss -d "Utility to investigate sockets"
    set -l cmd ss
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
