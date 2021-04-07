if command -qs rg
    and command -qs bzip2
    function bzfgrep
        command rg -zF $argv
    end
else if command -qs ugrep
    function bzfgrep
        command ugrep -zF $argv
        # ugrep --sort -F -U -Y -z -. -Dread -dread is more compatible
    end
end
