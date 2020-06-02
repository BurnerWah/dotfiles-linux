function mtr
  set -l cmd mtr
  if isatty stdout
    command -qs grc && set -p cmd grc
  end
  command $cmd $argv
end
