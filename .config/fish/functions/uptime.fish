function uptime
  if isatty stdout && command -qs grc
    command grc uptime $argv
  else
    command uptime $argv
  end
end
