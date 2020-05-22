if command -qs exa
  function ls -w exa -d "List contents of directory"
    set -l cmd ls
    set -l param --color=auto
    if isatty stdout
      set cmd exa
      set -a param --classify --color-scale
    end
    command $cmd $param $argv
  end
end
