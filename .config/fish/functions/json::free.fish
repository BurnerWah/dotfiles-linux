function json::free -w free -d "Display amount of free & uses memory in the system (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command free $argv \
       | jc --free \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command free $argv | jc --free
  end
end
