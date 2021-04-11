# unxz(1) completion
# NOTE this isn't as complete as xz's completions
complete -c unxz -x -a (_CM_suffixes .xz .txz .lzma .tlz)

complete -c unxz -s t -l test -d "Test the integrity of compressed files"
complete -c unxz -s l -l list -d "Print information about compressed files"
complete -c unxz -s k -l keep -d "Don't delete the input files"
complete -c unxz -s f -l force -d "Overwrite of output file"
complete -c unxz -s c -l stdout -d "Write to stdout instead of file"
# skipped
complete -xc unxz -s T -l threads -d 'Specify the number of worker threads to use'
# skipped
complete -c unxz -s q -l quiet -d 'Suppress warnings/notices'
complete -c unxz -s v -l verbose -d 'Be verbose'
# skipped
complete -c unxz -s h -l help -d 'Display help'
complete -c unxz -s H -l long-help -d 'Display long help'
complete -c unxz -s V -l version -d 'Display version'
