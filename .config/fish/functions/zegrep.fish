if command -qs ugrep
    function zegrep
        command ugrep -zE $argv
        # ugrep --sort -E -U -Y -z -. -Dread -dread is more compatible
    end
end
