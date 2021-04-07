if command -qs rg
    and command -qs gzip
    function zgrep
        command rg -z $argv
    end
else if command -qs ugrep
    # probably could check if ugrep has +zlib here
    function zgrep
        command ugrep -zG $argv
        # ugrep --sort -G -U -Y -z -. -Dread -dread is more compatible
    end
end
