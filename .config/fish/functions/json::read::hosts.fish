function json::read::hosts -d "Read /etc/hosts with JSON output"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    cat /etc/hosts \
       | jc --hosts \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    cat /etc/hosts | jc --hosts
  end
end
