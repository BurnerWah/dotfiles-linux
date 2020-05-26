function json::lsmod -w lsmod -d "Show the status of modules in the Linux Kernel (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command lsmod $argv \
       | jc --lsmod \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command lsmod $argv | jc --lsmod
  end
end
