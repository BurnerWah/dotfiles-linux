function mount
    set -l cmd mount
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
