function blkid
    set -l cmd blkid
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
