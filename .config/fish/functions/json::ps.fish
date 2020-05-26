function json::ps -w ps -d "Information about running processes (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command ps $argv \
       | jc --ps \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command ps $argv | jc --ps
  end
end
