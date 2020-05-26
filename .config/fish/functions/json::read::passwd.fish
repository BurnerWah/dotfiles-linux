if command -qs jq
  function json::read::passwd -d "Read /etc/passwd with JSON output"
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      cat /etc/passwd \
         | jc --passwd \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      cat /etc/passwd | jc --passwd
    end
  end
end
