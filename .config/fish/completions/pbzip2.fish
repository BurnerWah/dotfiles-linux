# pbzip2(1) completion
# target version: 1.1.13

complete -c pbzip2 -w bzip2

complete -c pbzip2 -x -s b -d "Block size in 100k steps (default: 900k)"
complete -c pbzip2 -s l -l loadavg -d "Max number processors to use"
complete -c pbzip2 -x -s m -d "Max memory usage in 1MB steps (default: 100MB)"
complete -c pbzip2 -x -s p -d "Number of processors to use (default: autodetect)"
complete -c pbzip2 -x -s S -d "Child thread stack size in 1KB steps (default stack size if unspecified)"

complete -c pbzip2 -r -l ignore-trailing-garbage= -d "Ignore trailing garbage flag" -a "1 2"
