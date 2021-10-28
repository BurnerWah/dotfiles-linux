# Make iostat(1) easier to read
function iostat -d "Report statistics for devices and partitions"
    set -l cmd iostat
    isatty stdout && set -p argv -h
    command $cmd $argv
end
