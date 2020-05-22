function ip -d "Show/manipulate routing, network devices, interfaces & tunnels"
  if isatty stdout && command -qs grc
    command grc ip $argv
  else
    command ip $argv
  end
end
