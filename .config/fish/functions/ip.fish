function ip -d "Show/manipulate routing, network devices, interfaces & tunnels"
    set -l cmd ip
    if isatty stdout
        command -qs grc && set -p cmd grc
    end
    command $cmd $argv
end
