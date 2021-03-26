# use pigz over gzip
if command -qs pigz
    function zcat
        command pigz -cd $argv
    end
end
