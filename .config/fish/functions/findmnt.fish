function findmnt
  if isatty stdout && command -qs grc
    command grc findmnt $argv
  else
    command findmnt $argv
  end
end
