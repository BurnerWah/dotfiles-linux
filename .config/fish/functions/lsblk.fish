function lsblk
  if isatty stdout && command -qs grc
    command grc lsblk $argv
  else
    command lsblk $argv
  end
end
