function sha1sum
    if command -qs rainbow
        command rainbow sha1sum $argv
    else
        command md5sum $argv
    end
end
