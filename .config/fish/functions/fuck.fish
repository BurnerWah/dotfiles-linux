# Modified output of `thefuck --alias`
function fuck -d "Correct your previous console command"
    set -l fucked_up_command $history[1]
    set -lx TF_SHELL fish
    set -lx TF_ALIAS fuck
    set -lx PYTHONIOENCODING utf-8
    thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
    if [ "$unfucked_command" != "" ]
        eval $unfucked_command
        builtin history delete -eC -- $fucked_up_command
        builtin history merge 2>/dev/null
    end
end
