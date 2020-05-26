function json::last -w last -d "Show a listing of last logged in users (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    command last $argv \
       | jc --last \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    command last $argv | jc --last
  end
end
