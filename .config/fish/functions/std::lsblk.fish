function std::lsblk -w lsblk -d "List block devices (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command lsblk --json $argv \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command lsblk --json $argv
  end
end
