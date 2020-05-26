function json::stat -w stat -d "Display file and filesystem information (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command stat $argv \
       | jc --stat \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command stat $argv | jc --stat
  end
end
