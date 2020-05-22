function semanage
  if isatty stdout && command -qs grc
    command grc semanage $argv
  else
    command semanage $argv
  end
end
