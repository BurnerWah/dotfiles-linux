function lsmod
  argparse --name=lsmod --ignore-unknown 'J/json' -- $argv
  set -l cmd lsmod
  if set -q _flag_json && command -qs jc
    if isatty stdout
      command $cmd | jc --du | _printers::json
    else
      command $cmd | jc --du
    end
  else
    if isatty stdout && command -qs grc
      set -p cmd grc
    end
    command $cmd $argv
  end
end

complete -c lsmod -s J -l json -d "Use JSON output format"
