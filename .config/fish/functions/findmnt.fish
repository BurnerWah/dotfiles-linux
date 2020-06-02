function findmnt
  set -l cmd findmnt
  if isatty stdout
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
