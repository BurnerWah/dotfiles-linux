if command -qs rg
    function fgrep
        command rg -F $argv
    end
else if command -qs ugrep
    function fgrep
        command ugrep -F $argv
    end
else if command -qs fgrep
    function fgrep
        command fgrep --color=auto $argv
    end
else
    function fgrep -w grep
        command grep -F --color=auto $argv
    end
end
