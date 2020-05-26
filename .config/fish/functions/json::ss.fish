function json::ss -w ss -d "Utility to investigate sockets (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command ss $argv \
       | jc --ss \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command ss $argv | jc --ss
  end
end
