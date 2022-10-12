function findmnt
    set -l cmd findmnt
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    if set -q DISTROBOX_ENTER_PATH
        set -p argv --uniq
    end
    command $cmd $argv
end
