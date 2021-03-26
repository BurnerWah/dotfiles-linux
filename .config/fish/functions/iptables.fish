function iptables
    set -l cmd iptables
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
