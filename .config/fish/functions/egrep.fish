if command -qs rg
    function egrep
        command rg $argv
    end
else if command -qs ugrep
    function egrep
        command ugrep -E $argv
        # technicall ugrep --sort -E -U -Y -. -Dread -dread is more compatible
    end
else if command -qs egrep
    function egrep
        command egrep --color=auto $argv
    end
else
    function egrep -w grep
        command grep -E --color=auto $argv
    end
end
