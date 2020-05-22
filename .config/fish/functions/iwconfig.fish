function iwconfig
  if isatty stdout && command -qs grc
    command grc iwconfig $argv
  else
    command iwconfig $argv
  end
end
