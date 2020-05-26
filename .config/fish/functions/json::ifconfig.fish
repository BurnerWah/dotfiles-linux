if command -qs ifconfig
  function json::ifconfig -w ifconfig -d "Configure a network interface (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command ifconfig $argv \
         | jc --ifconfig \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command ifconfig $argv | jc --ifconfig
    end
  end
end
