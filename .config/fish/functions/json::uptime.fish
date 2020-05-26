function json::uptime -w uptime -d "Tell how long the system has been running (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command uptime $argv \
       | jc --uptime \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command uptime $argv | jc --uptime
  end
end
