function iwconfig
  set -l cmd iwconfig
  if isatty stdout
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
