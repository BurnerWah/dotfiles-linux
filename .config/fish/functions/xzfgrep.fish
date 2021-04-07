if command -qs rg
    and command -qs xz
    function xzfgrep
        command rg -zF $argv
    end
else if command -qs ugrep
    function xzfgrep
        command ugrep -zF $argv
        # compatible version: ugrep --sort -F -U -Y -z -. -Dread -dread
    end
end
