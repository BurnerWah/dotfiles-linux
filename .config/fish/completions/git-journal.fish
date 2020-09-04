# These are adapted from the official git-journal completions to improve
# compatibility with git completion injection.
#
# Most flags cause errors if used after a subcommand

__require_git

set -l seen "__fish_seen_subcommand_from"
set -l prepare "p prepare"
set -l setup "s setup"
set -l verify "v verify"
set -l seen_subcmd "$seen $prepare $setup $verify help"
set -l is_subcmd "! $seen $prepare $setup $verify && ! contains_seq help help -- (commandline -poc)"

complete -c  git-journal -n "! $seen_subcmd" -s a -l all             -d "Don't stop parsing at the first tag when a single revision is given"
complete -c  git-journal -n "! $seen_subcmd" -s g -l generate        -d "Generate a fresh output template from a commit range"
complete -c  git-journal -n "! $seen help"   -s h -l help            -d "Prints help information"      # this is the only flag that doesn't always throw an error
complete -c  git-journal -n "! $seen_subcmd" -s s -l short           -d "Print only the shortlog (summary) form"
complete -c  git-journal -n "! $seen_subcmd" -s u -l skip-unreleased -d "Skip entries without any relation to a git TAG"
complete -c  git-journal -n "! $seen_subcmd" -s V -l version         -d "Prints version information"
complete -xc git-journal -n "! $seen_subcmd" -s i -l ignore          -d "Tags to ignore"               # currently can't be completed by fish
complete -rc git-journal -n "! $seen_subcmd" -s o -l output          -d "Output file for the changelog"
complete -xc git-journal -n "! $seen_subcmd" -s p -l path            -d "Sets a custom working path"   -a "(__fish_complete_directories)"
complete -xc git-journal -n "! $seen_subcmd" -s e                    -d "Pattern to exclude tags from the processing"
complete -xc git-journal -n "! $seen_subcmd" -s n -l tags-count      -d "Number of tags until the parser stops when a single revision is given"
complete -xc git-journal -n "! $seen_subcmd" -s t -l template        -d "Use a custom output template" # Not sure what this requires

complete -fc git-journal -n "$is_subcmd" -a prepare -d "Prepare a commit message before the user can edit it"
complete -fc git-journal -n "$is_subcmd" -a setup   -d "Create necessary git hooks and a configuration file"
complete -fc git-journal -n "$is_subcmd" -a verify  -d "Verify the specified commit message"
complete -fc git-journal -n "$is_subcmd" -a help    -d "Print help for a subcommand"

complete -kfc git-journal -a "(__fish_git_tags)" -d "Tag"
complete -kfc git-journal -a "(__fish_git_heads)" -d "Head"
complete -kfc git-journal -a "(__fish_git_recent_commits)"

# FIXME this has no effect
complete -Fc git-journal -n "$seen $prepare $verify && ! $seen help"

# TODO complete revision range
# TODO complete prepare/TYPE (may be impossible)
