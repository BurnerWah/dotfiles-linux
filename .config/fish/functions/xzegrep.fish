if command -qs rg
    and command -qs xz
    function xzegrep
        command rg -z $argv
    end
else if command -qs ugrep
    function xzegrep
        command ugrep -zE $argv
        # ugrep --sort -E -U -Y -z -. -Dread -dread is more compatible
    end
end
