# Defined interactively
function gif2mp4 --argument input output
    ffmpeg -i $input -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $output
end
