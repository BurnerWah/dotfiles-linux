# genact completion
# genact doesn't have a manual so this is derived from the help info
complete -fc genact
complete -c genact -s h -l help -d "Prints help information"
complete -c genact -s l -l list-modules -d "List available modules"
complete -c genact -s V -l version -d "Prints version information"
complete -xc genact -s e -l exitafter -d "Exit after running for this long"
complete -xc genact -s m -l modules -d "Run only these modules" \
    -a "(genact --list-modules | string match '  *' | string trim)\t"
