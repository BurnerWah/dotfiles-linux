function __require_git -d "Load git completions if needed"
  if ! type -q __fish_git
    if test -e $__fish_config_dir/completions/git.fish
      source $__fish_config_dir/completions/git.fish
    else if test -e $__fish_data_dir/completions/git.fish
      source $__fish_data_dir/completions/git.fish
    end
  end
end
