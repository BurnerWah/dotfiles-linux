function lsattr -d "List file attributes on a Linux file system"
    set -l cmd lsattr
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
