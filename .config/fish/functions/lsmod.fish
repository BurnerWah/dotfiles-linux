function lsmod
  if isatty stdout && command -qs grc
    command grc lsmod $argv
  else
    command lsmod $argv
  end
end
