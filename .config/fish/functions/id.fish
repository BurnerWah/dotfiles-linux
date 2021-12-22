if [ -L (command -qs id) ]
    # I'm assuing this is uutils
    function id -d "Display current user and group identity"
        isatty stdout && set -a argv -p
        command id $argv
    end
else
    function id -d "Display current user and group identity"
        set -l cmd id
        if isatty stdout
            command -qs grc && set -p cmd grc
        end
        command $cmd $argv
    end
end
