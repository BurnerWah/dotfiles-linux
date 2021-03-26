# Makes sar(1) easier to read
function sar
    set -l cmd sar
    isatty stdout && set -p argv -h
    command $cmd $argv
end
