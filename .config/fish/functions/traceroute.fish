function traceroute
  if isatty stdout && command -qs grc
    command grc traceroute $argv
  else
    command traceroute $argv
  end
end
