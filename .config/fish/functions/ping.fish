function ping
  if isatty stdout && command -qs grc
    command grc ping $argv
  else
    command ping $argv
  end
end
