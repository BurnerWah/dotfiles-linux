function json::env -d "Print environment (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command env \
       | jc --env \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command env | jc --env
  end
end
