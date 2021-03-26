set -l units \
    "none\t'no auto-scaling is done'" \
    "auto\t'1K = 1000, 1Ki = 1024, …'" \
    "si\t'1K = 1000, 1M = 1000000, …'" \
    "iec\t'1K = 1024, 1M = 1048576, …'" \
    "iec-i\t'1Ki = 1024, 1Mi = 1048576, …'"

complete -c numfmt -f

complete -c numfmt -l debug -d "Print warnings about invalid input"
complete -c numfmt -x -s d -l delimiter -d "Use X instead of whitespace for field delimiter"
complete -c numfmt -x -l fields -d "Replace the numbers in these input fields (default: 1)"
complete -c numfmt -x -l format -d "Use printf style floating-point FORMAT"
complete -c numfmt -x -l from -d "Auto-scale input numbers to UNIT" -a "$units"
complete -c numfmt -x -l from-unit -d "Specify the input unit size"
complete -c numfmt -l grouping -d "Use  locale-defined  grouping  of  digits"
complete -c numfmt -f -l header -d "Print (without converting) the first N header lines (default: 1)"
complete -c numfmt -x -l invalid -d "Failure mode for invalid numbers" -a "abort\tdefault fail warn ignore"
complete -c numfmt -x -l padding -d "Pad the output to N characters"
complete -c numfmt -x -l round -d "Use METHOD for rounding when scaling" -d "up down from-zero\tdefault towards-zero nearest"
complete -c numfmt -x -l suffix -d "Add SUFFIX to output numbers, and accept optional SUFFIX in input numbers"
complete -c numfmt -x -l to -d "Auto-scale output numbers to UNIT" -a "$units"
complete -c numfmt -x -l to-unit -d "The output unit size (default: 1)"
complete -c numfmt -s z -l zero-terminated -d "Line delimiter is NUL, not newline"
complete -c numfmt -l help -d "Display help & exit"
complete -c numfmt -l version -d "Display version & exit"
