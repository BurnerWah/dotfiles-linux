function getfacl
    set -l cmd getfacl
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
