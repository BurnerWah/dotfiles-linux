function iptables
  if isatty stdout && command -qs grc
    command grc iptables $argv
  else
    command iptables $argv
  end
end
