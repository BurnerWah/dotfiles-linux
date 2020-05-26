if [ (command -s route jc | count) = 2 ]
  function json::route -w route -d "Show / manipulate the IP routing table (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command route $argv \
         | jc --route \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command route $argv | jc --route
    end
  end
end
