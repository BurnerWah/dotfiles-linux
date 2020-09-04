# basename(1) completion is broken when auto-generated
complete -c basename -s a -l multiple -d "Support multiple arguments and treat each as a NAME"
complete -xc basename -s s -l suffix -d "Remove a trailing SUFFIX"
complete -c basename -s z -l zero -d "End each output line with NUL, not newline"
complete -c basename -l help -d "Display help & exit"
complete -c basename -l version -d "Display version & exit"
