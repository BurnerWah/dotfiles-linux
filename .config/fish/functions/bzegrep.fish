if command -qs rg
    and command -qs bzip2
    function bzegrep
        command rg -z $argv
    end
else if command -qs ugrep
    function bzegrep
        command ugrep -zE $argv
        # ugrep --sort -E -U -Y -z -. -Dread -dread is more compatible
    end
end
