function _fish_toolbox_prompt
    if test "$__fish_toolbox_prompt" -eq 1
        set_color magenta
        echo -n "⬢ "
        set_color normal
    end
end
