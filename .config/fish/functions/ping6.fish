if command -qs ping6
  function ping6
    if isatty stdout && command -qs grc
      command grc ping6 $argv
    else
      command ping6 $argv
    end
  end
end
