# Makes dmesg(1) easier to read
function dmesg
  set -l cmd dmesg
  isatty stdout && set -p argv --human
  command $cmd $argv
end
