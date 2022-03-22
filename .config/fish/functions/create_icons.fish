function create_icons --argument icon max_size src
    set -l sizes 16 24 32 48 64 96 128
    switch $max_size
        case 1024
            set -a sizes 192 256 512 1024
        case 512
            set -a sizes 192 256 512
        case 256
            set -a sizes 192 256
        case 192
            set -a sizes 192
    end
    for size in $sizes
        convert $src -resize {$size}x{$size} ~/.local/share/icons/hicolor/{$size}x{$size}/apps/{$icon}.png
    end
end
