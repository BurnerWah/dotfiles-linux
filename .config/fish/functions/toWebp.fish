function toWebp
    command convert $argv[1] -define webp:near-lossless=$argv[2] $argv[3]
end
