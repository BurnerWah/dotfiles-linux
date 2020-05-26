if command -qs dig
  function json::dig -w dig -d "DNS lookup utility (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command dig $argv \
         | jc --dig \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command dig $argv | jc --dig
    end
  end
end
