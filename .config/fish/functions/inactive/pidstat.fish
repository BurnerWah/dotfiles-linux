function pidstat
    set -l cmd pidstat
    isatty stdout && set -p argv --human
    command $cmd $argv
end
