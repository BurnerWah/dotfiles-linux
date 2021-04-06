if command -qs ugrep
    function xzfgrep
        command ugrep -zF $argv
        # compatible version: ugrep --sort -F -U -Y -z -. -Dread -dread
    end
end
