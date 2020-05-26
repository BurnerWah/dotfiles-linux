function json::w -w w -d "Show who is logged on and what they are doing (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command w $argv \
       | jc --w \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command w $argv | jc --w
  end
end
