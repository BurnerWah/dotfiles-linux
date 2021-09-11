# Defined interactively
function e6_gif2mp4_bulk
    for i in (fd -tf -egif)
        set -l name (echo $i | string replace .gif '')
        gif2mp4 $name.gif $name.mp4
        gio trash $name.gif
        ln -s $name.mp4 $name.gif
    end
end
