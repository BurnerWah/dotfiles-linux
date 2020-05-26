function json::read::fstab -d "Static information about the filesystems (JSON output)"
  if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
    cat /etc/fstab \
       | jc --fstab \
       | prettier --parser json --print-width (tput cols) \
       | bat --language=json --paging=never --color=always --style=plain
  else
    cat /etc/fstab | jc --fstab
  end
end
