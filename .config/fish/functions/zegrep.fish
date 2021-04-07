if command -qs rg
    and command -qs gzip
    function rg
        command rg -z $argv
    end
else if command -qs ugrep
    function zegrep
        command ugrep -zE $argv
        # ugrep --sort -E -U -Y -z -. -Dread -dread is more compatible
    end
end
