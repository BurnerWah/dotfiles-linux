# gtk-update-icon-cache
# generates really bad descriptions by default
complete -c gtk-update-icon-cache -x -a "(__fish_complete_directories)"

complete -c gtk-update-icon-cache -l help -s h -d "Show help options"
complete -c gtk-update-icon-cache -l force -s f -d "Overwrite an existing cache, even if up to date"
complete -c gtk-update-icon-cache -l ignore-theme-index -s t -d "Don't check for an index.theme"
complete -c gtk-update-icon-cache -l index-only -s i -d "Don't include image data in the cache"
complete -c gtk-update-icon-cache -l include-image-data -d "Include image data in the cache"
complete -c gtk-update-icon-cache -l source -s c -d "Output a C header file"
complete -c gtk-update-icon-cache -l quiet -s q -d "Turn off verbose output"
complete -c gtk-update-icon-cache -l validate -s v -d "Validate existing icon cache"
