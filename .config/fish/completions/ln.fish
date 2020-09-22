# applies fix to standard completions

source $__fish_data_dir/completions/ln.fish

complete -fc ln -l backup -d 'Make a backup of each existing destination file' -a "none off numbered t existing nil simple never"
