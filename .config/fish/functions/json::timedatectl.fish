function json::timedatectl
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    timedatectl status \
       | jc --timedatectl \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    timedatectl status | jc --timedatectl
  end
end
