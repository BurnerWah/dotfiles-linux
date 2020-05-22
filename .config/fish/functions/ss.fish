function ss -d "Utility to investigate sockets"
  if isatty stdout && command -qs grc
    command grc ss $argv
  else
    command ss $argv
  end
end
