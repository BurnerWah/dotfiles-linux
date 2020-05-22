if command -qs exa
  function exa
    set -l param --color=auto --color-scale
    isatty stdout && set -a param --classify
    command exa $param $argv
  end
end
