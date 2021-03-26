function semanage
    set -l cmd semanage
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
