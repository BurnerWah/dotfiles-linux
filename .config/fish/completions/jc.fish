# jc completions
# We need to have installed to effectively parse things. Some arguments are

complete -c jc -s a -d "Aboug jc" -n __fish_use_subcommand
complete -c jc -s d -d Debug -n __fish_use_subcommand
complete -c jc -s m -d "Monochrome output" -n __fish_use_subcommand
complete -c jc -s p -d "Pretty print output" -n __fish_use_subcommand
complete -c jc -s q -d "Suppress warnings" -n __fish_use_subcommand
complete -c jc -s r -d "Raw JSON output" -n __fish_use_subcommand

if [ (uname) = Linux ]
    # NOTE There doesn't seem to be a good way to include descriptions without
    # making this run horribly or caching data
    for i in (
        jc -a | \
        jq -cr '.parsers | map(select(.compatible | contains(["linux"]))) | .[].argument' | \
        string trim -lc --
        )
        complete -c jc -l $i -n __fish_use_subcommand
    end
    # NOTE we have to remove anything with a space in it as we can't parse it
    # correctly
    for i in (
        jc -a | \
        jq -cr '.parsers | map(select((.compatible | contains(["linux"])) and has("magic_commands"))) | .[].magic_commands[]' | \
        string match -v '* *'
        )
        complete -c jc -x -a $i -n __fish_use_subcommand
    end
end

# NOTE we can't really do anything to stop
complete -c jc -n "! __fish_use_subcommand" -xa "(__fish_complete_subcommand)"
