function json::du -w du -d "Estimate file space usage (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command du $argv \
       | jc --du \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command du $argv | jc --du
  end
end
