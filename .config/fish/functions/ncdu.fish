# makes ncdu(1) use colors and SI units
if command -qs ncdu
    function ncdu
        command ncdu --si --color dark $argv
    end
end
