complete -c nohup -n 'test (count (commandline -opc)) -eq 1' -l help -d 'Display help & exit'
complete -c nohup -n 'test (count (commandline -opc)) -eq 1' -l version -d 'Display version & exit'
complete -c nohup -xa "(__fish_complete_subcommand)"
