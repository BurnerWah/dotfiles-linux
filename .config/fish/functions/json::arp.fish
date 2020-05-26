if [ (command -s arp jc | count) = 2 ]
  function json::arp -w arp -d "Manipulate the system ARP cache (JSON output)"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      command arp $argv \
         | jc --arp \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      command arp $argv | jc --arp
    end
  end
end
