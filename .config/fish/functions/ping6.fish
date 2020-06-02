if command -qs ping6
  function ping6
    set -l cmd ping6
    if isatty stdout
      command -qs grc && set -p cmd grc
    end
    command $cmd $argv
  end
end
