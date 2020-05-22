if command -qs egrep
  function egrep
    command egrep --color=auto $argv
  end
else
  function egrep -w grep
    command grep -E --color=auto $argv
  end
end
