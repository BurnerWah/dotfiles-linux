# Makes dmesg(1) easier to read
function dmesg
  set -l cmd dmesg
  isatty stdout && set -a cmd --human
  command $cmd $argv
end
