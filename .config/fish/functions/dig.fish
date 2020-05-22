function dig --description "DNS lookup utility"
  if isatty stdout && command -qs grc
    command grc dig $argv
  else
    command dig $argv
  end
end
