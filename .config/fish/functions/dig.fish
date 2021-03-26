function dig --description "DNS lookup utility"
    set -l cmd dig
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
