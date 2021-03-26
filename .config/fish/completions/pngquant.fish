# pngquant(1)
complete -c pngquant -r -s o -l output -d "Writes converted file to the given path"
complete -c pngquant -x -l ext -d "File extension (suffix) to use for output files"
complete -c pngquant -s f -l force -d "Overwrite existing output files"
complete -c pngquant -x -l floyd -d "Set dithering level using fractional number between 0 and 1"
complete -c pngquant -x -s s -l speed -d "Speed/quality trade-off. 1=slow, 4=default, 11=fast & rough"
complete -c pngquant -x -s Q -l quality -d "Don't save below min, use fewer colors below max (0-100)"
complete -c pngquant -l skip-if-larger -d "Only save converted files if they're smaller than original"
complete -c pngquant -x -l posterize -d "Truncate number of least significant bits of color (per channel)"
complete -c pngquant -l strip -d "Remove optional metadata"
complete -c pngquant -l transbug -d "Workaround for readers"
complete -c pngquant -s v -l verbose -d "Enable verbose messages"
complete -c pngquant -s V -l version -d "Display version and exit"
complete -c pngquant -s h -l help -d "Display help and exit"

complete -c pngquant -l nofs -l ordered -d 'Disable Floyd-Steinberg dithering'
