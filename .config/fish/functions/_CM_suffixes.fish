function _CM_suffixes -d "Completion macro for __fish_complete_suffix"
    echo -n "("
    for suffix in $argv
        echo -n "__fish_complete_suffix $suffix;"
    end
    echo -n ")"
end
