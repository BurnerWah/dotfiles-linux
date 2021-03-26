function lastlog -d "Show the most recent login of all users or of a given user"
    set -l cmd lastlog
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
