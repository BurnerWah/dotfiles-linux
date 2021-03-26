function lsblk
    set -l cmd lsblk
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
