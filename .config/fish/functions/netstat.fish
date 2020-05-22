function netstat -d "Displays network-related information"
  if isatty stdout && command -qs grc
    command grc netstat $argv
  else
    command netstat $argv
  end
end
