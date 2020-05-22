function lsattr -d "List file attributes on a Linux file system"
  if isatty stdout && command -qs grc
    command grc lsattr $argv
  else
    command lsattr $argv
  end
end
