# injects completions into builtin git.fish
source $__fish_data_dir/completions/git.fish

function __fish_git_custom_commands
    # complete all commands starting with git-
    # however, a few builtin commands are placed into $PATH by git because
    # they're used by the ssh transport. We could filter them out by checking
    # if any of these completion results match the name of the builtin git commands,
    # but it's simpler just to blacklist these names. They're unlikely to change,
    # and the failure mode is we accidentally complete a plumbing command.
    for name in (string replace -r "^.*/git-([^/]*)" '$1' $PATH/git-*)
        switch $name
            case cvsserver receive-pack shell upload-archive upload-pack remote-\*
                # skip these
            case \*
                echo $name
        end
    end
end

for custom_command in (__fish_git_custom_commands)
  complete -c git -n "__fish_git_using_command $custom_command" -w "git-$custom_command"
end
