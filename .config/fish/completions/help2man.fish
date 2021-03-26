# help2man(1) - a manual generator
complete -c help2man -x -a "(__fish_complete_external_command)"

complete -c help2man -l help -d 'Print this help, then exit'
complete -c help2man -l version -d 'Print version number, then exit'

complete -c help2man -x -s n -l name -d 'Description for the NAME paragraph'
complete -c help2man -x -s s -l section -d 'Section number for manual page'
complete -c help2man -x -s m -l manual -d 'Name of manual'
complete -c help2man -x -s S -l source -d 'Source of program'
complete -c help2man -x -s L -l locale -d 'Select locale'
complete -c help2man -r -s i -l include -d 'Include material from FILE'
complete -c help2man -r -s I -l opt-include -d 'Include material from FILE if it exists'
complete -c help2man -r -s o -l output -d 'Send output to FILE'
complete -c help2man -x -s p -l info-page -d 'Name of Texinfo manual'
complete -c help2man -s N -l no-info -d 'Suppress pointer to Texinfo manual'
complete -c help2man -s l -l libtool -d 'Exclude the "lt-" from the program name'
complete -c help2man -x -l version-string -d 'Version string'

complete -c help2man -x -s h -l help-option -d 'Help option string'
complete -c help2man -x -s v -l version-option -d 'Version option string'

complete -c help2man -l no-discard-stderr -d 'Include stderr when parsing option output'
