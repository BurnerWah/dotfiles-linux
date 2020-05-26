function json::mount -w mount -d "Mount a filesystem (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command mount $argv \
       | jc --mount \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command mount $argv | jc --mount
  end
end
