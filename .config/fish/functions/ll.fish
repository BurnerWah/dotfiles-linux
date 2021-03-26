set -l description "List contents of directory using long format"
if command -qs exa
    function ll -w "exa -lF" -d "$description"
        exa --long $argv
    end
else
    function ll -w ls -d "$description"
        ls -lh $argv
    end
end
