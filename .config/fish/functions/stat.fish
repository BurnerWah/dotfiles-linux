function stat
  if isatty stdout && command -qs grc
    command grc stat $argv
  else
    command stat $argv
  end
end
