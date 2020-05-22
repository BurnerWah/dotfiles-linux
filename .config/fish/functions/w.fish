function w
  if isatty stdout && command -qs grc
    command grc w $argv
  else
    command w $argv
  end
end
