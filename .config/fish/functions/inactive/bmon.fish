# Makes bmon(8) use SI units
if command -qs bmon
    function bmon
        command bmon --use-si $argv
    end
end
