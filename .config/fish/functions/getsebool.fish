function getsebool
  if isatty stdout && command -qs grc
    command grc getsebool $argv
  else
    command getsebool $argv
  end
end
