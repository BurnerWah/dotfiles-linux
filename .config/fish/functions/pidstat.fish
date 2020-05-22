function pidstat
  set -l cmd pidstat
  isatty stdout && set -a cmd --human
  command $cmd $argv
end
