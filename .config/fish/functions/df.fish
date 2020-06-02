function df
  set -l cmd df
  if isatty stdout
    set -p argv --human-readable --si
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
