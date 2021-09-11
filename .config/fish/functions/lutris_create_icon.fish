function lutris_create_icon --argument icon max_size src
    set -l sizes 16 20 24 32 40 48 64 72 96 128
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
        convert $src -resize {$size}x{$size} ~/.local/share/icons/hicolor/{$size}x{$size}/apps/lutris_{$icon}.png
    end
end
