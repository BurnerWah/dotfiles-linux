function lspci
    set -l cmd lspci
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
