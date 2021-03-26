# hexyl 0.7.0 completion
complete -xc hexyl -s n -s c -l length -l bytes -d "Read only N bytes from the input"

complete -c hexyl -s v -l no-squeezing -d "Displays all input data"
complete -xc hexyl -l color -d "When to use colors" -a "always\tDefault auto never"
complete -xc hexyl -l border -d "What border to draw" -a "unicode\tDefault ascii none"
complete -xc hexyl -s o -l display-offset -d "Add OFFSET to the displayed file position"
complete -c hexyl -s h -l help -d "Prints help information"
complete -c hexyl -s V -l version -d "Prints version information"
