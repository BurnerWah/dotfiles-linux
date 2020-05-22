function blkid
  if isatty stdout && command -qs grc
    command grc blkid $argv
  else
    command blkid $argv
  end
end
