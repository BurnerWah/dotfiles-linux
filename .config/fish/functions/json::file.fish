if command -qs file
  function json::file -w file -d "Determine file type (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command file $argv \
         | jc --file \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command file $argv | jc --file
    end
  end
end
