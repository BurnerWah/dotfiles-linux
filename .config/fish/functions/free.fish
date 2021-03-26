# Makes free(1) easier to read
function free -d "Display amount of free & used memory in the system"
    set -l cmd free
    if isatty stdout
        set -p argv --human --si
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
