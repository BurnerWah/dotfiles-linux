function mtr
  if isatty stdout && command -qs grc
    command grc mtr $argv
  else
    command mtr $argv
  end
end
