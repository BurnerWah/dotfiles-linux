function id -d "Display current user and group identity"
  set -l cmd id
  if isatty stdout
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
