function json::read::group -d "Read /etc/group with JSON output"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    cat /etc/group \
       | jc --group \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    cat /etc/group | jc --group
  end
end
