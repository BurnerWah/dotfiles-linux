function lastlog -d "Show the most recent login of all users or of a given user"
  if isatty stdout && command -qs grc
    command grc lastlog $argv
  else
    command lastlog $argv
  end
end
