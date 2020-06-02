function df
  argparse --name=df --ignore-unknown 'J-json' -- $argv
  set -l cmd df
  if contains -- --help $argv || contains -- --version $argv
    command $cmd $argv
  else if set -q _flag_json && command -qs jc
    if isatty stdout
      command $cmd $argv | jc --df | _printers::json
    else
      command $cmd $argv | jc --df
    end
  else
    if isatty stdout
      set -p argv --human-readable --si
      command -qs grc && set -p cmd grc
    end
    command $cmd $argv
  end
end

complete -c df -l json -d "Use JSON output format"
