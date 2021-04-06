complete -c zgrep -w grep
complete -c zdiff -xa "(
    __fish_complete_suffix .gz
    __fish_complete_suffix .tgz
)"
# NOTE .tgz might not be valid here
