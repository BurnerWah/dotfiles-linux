if command -qs lsof
  function json::lsof -w lsof -d "List open files (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command lsof $argv \
         | jc --lsof \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command lsof $argv | jc --lsof
    end
  end
end
