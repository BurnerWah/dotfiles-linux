if command -qs exa
    function ls -w "exa -F" -d "List contents of directory"
        set -l cmd ls
        set -l param --color=auto
        if isatty stdout
            set cmd exa
            set -a param --classify --color-scale
        end
        command $cmd $param $argv
    end
else if [ -e $__fish_data_dir/functions/ls.fish ]
    source $__fish_data_dir/functions/ls.fish
end
