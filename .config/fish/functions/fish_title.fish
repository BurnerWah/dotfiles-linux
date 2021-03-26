function fish_title -d "Generates title of fish shell"
    # Cache current command since it's used in multiple branches
    set -l cmd (status current-command)
    # TODO pre-process $cmd to correct value
    switch $cmd
        case : cd commandline help z
            # Skip drawing title on simple builtins/commands
            return

        case begin source
            # Make output more descriptive on operations that are likely to block
            printf "fish: $cmd %s" (prompt_pwd)

        case '*'
            # Fallback to ismple output
            printf "$cmd %s" (prompt_pwd)
    end
end
