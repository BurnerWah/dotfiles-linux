function X_clipboard_clear
    if type -q pbcopy
        cat /dev/null | pbcopy
    else if set -q WAYLAND_DISPLAY; and type -q wl-copy
        echo -n | wl-copy
    else if type -q xsel
        cat /dev/null | xsel -b -l /dev/null 2>/dev/null
    else if type -q xclip
        cat /dev/null | xclip -selection clipboard 2>/dev/null
    end
end
