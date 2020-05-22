# Makes df(1) easier to read
function df
  set -l cmd df
  if isatty stdout
    set -a cmd --human-readable --si
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
