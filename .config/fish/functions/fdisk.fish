function fdisk
  if isatty stdout && command -qs grc
    command grc fdisk $argv
  else
    command fdisk $argv
  end
end
