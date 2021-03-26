complete -c znew -xa "(__fish_complete_suffix .Z)"
complete -c znew -s f -d "Force recompression even if a .gz file already exists"
complete -c znew -s t -d "Test the new files before deleting originals"
complete -c znew -s v -d Verbose
complete -c znew -s 9 -d "Use the slowest compression method (optimal compression)"
complete -c znew -s P -d "Use pipes for the conversion to reduce disk space usage"
complete -c znew -s K -d "Keep a .Z file when it is smaller than the .gz file"
complete -c znew -l help -d "Display help & exit"
complete -c znew -l version -d "Display version & exit"
