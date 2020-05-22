# Makes sar(1) easier to read
function sar
  set -l cmd sar
  isatty stdout && set -a cmd -h
  command $cmd $argv
end
