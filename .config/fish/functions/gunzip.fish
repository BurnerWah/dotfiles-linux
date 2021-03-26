# Use unpigz over gunzip
if command -qs unpigz
    function gunzip -w unpigz
        command unpigz $argv
    end
end
