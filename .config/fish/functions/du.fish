# Makes du(1) easier to read
function du
  set -l cmd du
  if isatty stdout
    set -a cmd --human-readable --si
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
