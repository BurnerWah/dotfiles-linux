complete -c link -r
complete -c link -f -n "[ (commandline -poc | string split ' ' | string match -v -- '--*' | count) -gt 2 ]"
complete -c link -l help -d "Display help & exit"
complete -c link -l version -d "Display version & exit"
