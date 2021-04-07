if command -qs rg
    and command -qs bzip2
    function bzgrep
        command rg -z $argv
    end
else if command -qs ugrep
    # probably could check if ugrep has +bzip2 here
    function bzgrep
        command ugrep -zG $argv
        # ugrep --sort -G -U -Y -z -. -Dread -dread is more compatible
    end
end
