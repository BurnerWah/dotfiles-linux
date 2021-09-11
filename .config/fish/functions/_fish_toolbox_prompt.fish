function _fish_toolbox_prompt
    if [ "$__fish_toolbox_prompt" = 1 ]
        set_color magenta
        echo -n "⬢ "
        set_color normal
    end
end
