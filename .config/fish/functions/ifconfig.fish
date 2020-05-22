function ifconfig
  if isatty stdout && command -qs grc
    command grc ifconfig $argv
  else
    command ifconfig $argv
  end
end
