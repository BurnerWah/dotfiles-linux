# Use pigz over gzip
if command -qs pigz
    function gzip -w pigz
        command pigz $argv
    end
end
