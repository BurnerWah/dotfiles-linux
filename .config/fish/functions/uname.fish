function uname
  argparse --name=uname --ignore-unknown 'J-json' -- $argv
  set -l cmd uname
  if contains -- --help $argv || contains -- --version $argv
    command $cmd $argv
  else if set -q _flag_json && command -qs jc
    if isatty stdout
      command $cmd -a $argv | jc --uname | _printers::json
    else
      command $cmd -a $argv | jc --uname
    end
  else
    command $cmd $argv
  end
end

complete -c uname -l json -d "Use JSON output format"
