if command -qs rg
    and command -qs xz
    function xzgrep
        command rg -z $argv
    end
else if command -qs ugrep
    # probably could check if ugrep has +lzma here
    function xzgrep
        command ugrep -zG $argv
        # ugrep --sort -G -U -Y -z -. -Dread -dread is more compatible
    end
end
