if command -qs netstat
  function json::netstat -w netstat -d "Displays network-related information (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command netstat $argv \
         | jc --netstat \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command netstat $argv | jc --netstat
    end
  end
end
