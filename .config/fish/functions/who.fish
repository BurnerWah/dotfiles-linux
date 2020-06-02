function who
  argparse --name=who --ignore-unknown 'H-help' 'V-version' 'J/json' -- $argv
  set -l cmd who
  if set -q _flag_help
    command $cmd --help $argv
  else if set -q _flag_version
    command $cmd --version $argv
  else if set -q _flag_json && command -qs jc
    if isatty stdout
      command $cmd $argv | jc --who | _printers::json
    else
      command $cmd $argv | jc --who
    end
  else
    comand $cmd $argv
  end
end

complete -c who -s J -l json -d "Use JSON output format"
