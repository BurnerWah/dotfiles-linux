set -l description "List contents of directory, including hidden files in directory using long format"
if command -qs exa
  function la -w "exa -laF" -d "$description"
    exa --long --all $argv
  end
else
  function la -w ls -d "$description"
    ls -lah $argv
  end
end
