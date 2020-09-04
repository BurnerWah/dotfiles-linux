complete -c mkfifo -x -s m -l mode -d "Set file permission bits to MODE, not a=rw - umask"
complete -c mkfifo -s Z -d "Set the SELinux security context to default type"
complete -c mkfifo -f -l context -d "Like -Z, or set the SELinux or SMACK security context to CTX" # CTX can't be completed yet
complete -c mkfifo -l help -d "Display help & exit"
complete -c mkfifo -l version -d "Display version & exit"
