if command -qs ugrep
    function zfgrep
        command ugrep -zF $argv
        # compatible version: ugrep --sort -F -U -Y -z -. -Dread -dread
    end
end
