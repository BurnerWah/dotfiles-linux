# xzcat(1) completion
# completions are generally modeled after zcat's completions
complete -c xzcat -x -a (_CM_suffixes .xz .txz .lzma -tlz)

complete -c xzcat -s f -l force -d "Overwrite of output file"
# skipped
complete -xc xzcat -s T -l threads -d 'Specify the number of worker threads to use'
# skipped
complete -c xzcat -s q -l quiet -d 'Suppress warnings/notices'
complete -c xzcat -s v -l verbose -d 'Be verbose'
# skipped
complete -c xzcat -s h -l help -d 'Display help'
complete -c xzcat -s H -l long-help -d 'Display long help'
complete -c xzcat -s V -l version -d 'Display version'
