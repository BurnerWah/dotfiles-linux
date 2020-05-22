function lspci
  if isatty stdout && command -qs grc
    command grc lspci $argv
  else
    command lspci $argv
  end
end
