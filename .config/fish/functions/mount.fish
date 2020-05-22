function mount
  if isatty stdout && command -qs grc
    command grc mount $argv
  else
    command mount $argv
  end
end
