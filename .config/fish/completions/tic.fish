# NOTE these aren't really finished
set -l verbosity \
    "1\t'Names of files created and linked (default)'" \
    "2\t'Information related to the \"use\" facility'" \
    "3\t'Statistics from the hashing algorithm'" \
    "5\t'String-table memory allocations'" \
    "7\t'Entries into the string-table'" \
    "8\t'List of tokens encountered by scanner'" \
    "9\t'All values computed in construction of the hash table'"
complete -c tic -s 0 -d "format translation output all capabilities on one line"
complete -c tic -s 1 -d "format translation output one capability per line"
complete -c tic -s a -d "retain commented-out capabilities (sets -x also)"
complete -c tic -s C -d "translate entries to termcap source form"
complete -c tic -s c -d "print list of tic's database locations (first must be writable)"
complete -c tic -s D -d "check only, validate input without compiling or translating"
complete -c tic -x -s e -d "translate/compile only entries named by comma-separated list"
complete -c tic -s f -d "format complex strings for readability"
complete -c tic -s G -d "format %{number} to %'char'"
complete -c tic -s g -d "format %'char' to %{number}"
complete -c tic -s I -d "translate entries to terminfo source form"
complete -c tic -s K -d "translate entries to termcap source form with BSD syntax"
complete -c tic -s L -d "translate entries to full terminfo source form"
complete -c tic -s N -d "disable smart defaults for source translation"
complete -c tic -x -s o -d "set output directory for compiled entry writes" \
    -a "(__fish_complete_directories)"
complete -c tic -x -o Q -d "dump compiled description" \
    -a "1\thexadecimal 2\tbase64 3\t'hexadecimal and base64'"
complete -c tic -s q -d "brief listing, removes headers"
complete -c tic -x -s R -d "restrict translation to given terminfo/termcap version" \
    -a "SVr1 Ultrix HP BSD AIX"
complete -c tic -s r -d "force resolution of all use entries in source translation"
complete -c tic -s s -d "print summary statistics"
complete -c tic -s T -d "remove size-restrictions on compiled description"
complete -c tic -s t -d "suppress commented-out capabilities"
complete -c tic -s U -d "suppress post-processing of entries"
complete -c tic -s V -d "print version"
complete -c tic -x -s v -d "set verbosity level" -a "$verbosity"
complete -c tic -s W -d "wrap long strings according to -w[n] option"
complete -c tic -x -s w -d "set format width for translation output"
complete -c tic -s x -d "treat unknown capabilities as user-defined" \
    -n "__fish_not_contain_opt -s a"
