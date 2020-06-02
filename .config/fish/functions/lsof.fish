function lsof
  set -l cmd lsof
  if isatty stdout
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
