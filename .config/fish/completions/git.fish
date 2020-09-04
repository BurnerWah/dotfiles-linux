# injects completions into builtin git.fish
source $__fish_data_dir/completions/git.fish

# git-journal
if command -qs git-journal
  complete -fc git -n "__fish_git_needs_command" -a journal -d "Commit Message & Changelog Generation Framework"
  complete -fc git -n "__fish_git_using_command journal" -w git-journal
end

# git-trim
if command -qs git-trim
  complete -fc git -n "__fish_git_needs_command" -a trim -d "Trim tracking branches whose upstream branches are merged or stray"
  complete -fc git -n "__fish_git_using_command trim" -w git-trim
end
