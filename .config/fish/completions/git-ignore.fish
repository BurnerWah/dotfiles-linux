__require_git
set -l using "__fish_git_using_command ignore"

complete -c git-ignore -n "$using" -s h -l help -d "Prints help information"
complete -c git-ignore -n "$using" -s l -l list -d "List <templates> or all available templates"
complete -c git-ignore -n "$using" -s u -l update -d "Update templates by fetching them from gitignore.io"
complete -c git-ignore -n "$using" -s V -l version -d "Prints version information"

# We could hypothetically use jq to generate richer completions, but there's no
# real benefit to doing so. The descriptions aren't very good, and we'd still
# need to fall back on calling git-ignore sometimes to generate a cache.
# Most importantly, scripting around git-ignore is faster, so there's no reason
# to do anything else.

complete -c git-ignore -n "$using" -x -a "(git-ignore -l 2> /dev/null | string trim | string match '\"*' | string replace -r '^\"(.+)\",\$' '\$1')"
