function json::uname -d "Print system information (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command uname -a \
       | jc --uname \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command uname -a | jc --uname
  end
end
