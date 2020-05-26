function json::ls -w ls -d "List directory contents (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command ls $argv \
       | jc --ls \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command ls $argv | jc --ls
  end
end
