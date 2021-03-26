# stow completion
# not the most elegant but they get the job done
complete -xc stow -a "(__fish_complete_directories)"

complete -xc stow -s d -l dir -d "Set stow dir to DIR (default is current dir)" -a "(__fish_complete_directories)"
complete -xc stow -s t -l target -d "Set target to DIR (default is parent of stow dir)" -a "(__fish_complete_directories)"
complete -c stow -s S -l stow -d "Stow the package names that follow this option"
complete -c stow -s D -l delete -d "Unstow the package names that follow this option"
complete -c stow -s R -l restow -d "Restow (like stow -D followed by stow -S)"
complete -xc stow -l ignore -d "Ignore files ending in this Perl regex"
complete -xc stow -l defer -d "Don't stow files beginning with this Perl regex"
complete -xc stow -l override -d "Force stowing files beginning with this Perl regex"
complete -c stow -l adopt -d "Import existing files into stow package from target"
complete -c stow -s p -l compat -d "Use legacy algorithm for unstowing"
complete -c stow -s V -l version -d "Show stow version number"
complete -c stow -s h -l help -d "Show this help"

# this could be cleaned up
complete -c stow -s v -l verbose -d "Increase verbosity" -n "! __fish_contains_opt -s v verbose verbose=0 verbose=1 verbose=2 verbose=3 verbose=4 verbose=5"
complete -c stow --long-option=verbose={0,1,2,3,4,5} -d "Set verbosity" -n "! __fish_contains_opt -s v verbose verbose=0 verbose=1 verbose=2 verbose=3 verbose=4 verbose=5"

complete -c stow -s n -l no -l simulate -d "Don't actually make any filesystem changes"
