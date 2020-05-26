function json::df -w df -d "Report file system disk space usage (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command df $argv \
       | jc --df \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command df $argv | jc --df
  end
end
