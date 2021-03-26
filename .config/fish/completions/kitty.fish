function __kitty_completions
    # Send all words up to the one before the cursor
    # unescape response because kitty erroneously escapes it
    commandline -cop | kitty +complete fish | string unescape
end

complete -f -c kitty -a "(__kitty_completions)"
