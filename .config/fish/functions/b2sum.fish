function b2sum
    if command -qs rainbow
        command rainbow b2sum $argv
    else
        command b2sum $argv
    end
end
