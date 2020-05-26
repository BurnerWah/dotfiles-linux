function json::who -w who -d "Show who is logged on (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command who $argv \
       | jc --who \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command who $argv | jc --who
  end
end
