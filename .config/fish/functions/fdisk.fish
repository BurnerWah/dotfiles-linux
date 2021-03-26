function fdisk
    set -l cmd fdisk
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
