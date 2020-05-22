function ps -d "Information about running processes"
  if isatty stdout && command -qs grc
    command grc ps $argv
  else
    command ps $argv
  end
end
