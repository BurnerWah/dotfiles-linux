function w
  argparse --name=w --ignore-unknown 'H-help' 'V/version' 'J/json' -- $argv
  set -l cmd w
  if set -q _flag_help
    command $cmd --help $argv
  else if set -q _flag_V
    command $cmd --version $argv
  else if set -q _flag_J && command -qs jc
    if isatty stdout
      command $cmd $argv | jc --w | _printers::json
    else
      command $cmd $argv | jc --w
    end
  else
    if isatty stdout
      command -qs grc && set -p cmd grc
    end
    command $cmd $argv
  end
end
