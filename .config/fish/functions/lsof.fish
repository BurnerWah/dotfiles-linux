function lsof
  if isatty stdout && command -qs grc
    command grc lsof $argv
  else
    command lsof $argv
  end
end
