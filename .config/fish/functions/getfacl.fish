function getfacl
  if isatty stdout && command -qs grc
    command grc getfacl $argv
  else
    command getfacl $argv
  end
end
