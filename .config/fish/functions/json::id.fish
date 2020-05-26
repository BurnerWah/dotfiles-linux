function json::id -w id -d "Print real & effective user & group IDs (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command id $argv \
       | jc --id \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command id $argv | jc --id
  end
end
