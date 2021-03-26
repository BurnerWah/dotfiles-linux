# prefer pbzcat to bzcat
if command -qs pbzcat
    function bzcat
        command pbzcat $argv
    end
end
