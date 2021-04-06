if command -qs ugrep
    # probably could check if ugrep has +bzip2 here
    function bzgrep
        command ugrep -zG $argv
        # ugrep --sort -G -U -Y -z -. -Dread -dread is more compatible
    end
end
