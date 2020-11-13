# Targets onefetch 2.5.0

set -l fields \
   GitInfo Project HEAD Version Created Languages Authors LastChange Repo \
   Commits Pending LinesOfCode Size License

complete -fc onefetch -a "(__fish_complete_directories)"

complete -xc onefetch -s a -l ascii-language   -d "Which language's ascii art to print"           -a "(onefetch --languages)"
complete -xc onefetch -s d -l disable-fields   -d "Disable field(s) from appearing in the output" -a "$fields"
complete -xc onefetch -s c -l ascii-colors     -d "Colors (X X X...) for the ascii art"
complete -c  onefetch      -l no-bold          -d "Turns off bold formatting"
complete -c  onefetch -s l -l languages        -d "Prints out supported languages"
complete -Fc onefetch -s i -l image            -d "Path to the image file"
complete -xc onefetch      -l image-backend    -d "Which image backend to use"                    -a "kitty sixel"
complete -c  onefetch      -l no-merge-commits -d "Ignores merge commits"
complete -c  onefetch      -l no-color-blocks  -d "Hides the color blocks"
complete -xc onefetch -s A -l authors          -d "NUM of authors to be shown [default: 3]"
complete -Fc onefetch -s e -l exclude          -d "Ignore all files & directories matching EXCLUDE"
complete -c  onefetch -s h -l help             -d "Prints help information"
complete -c  onefetch -s V -l version          -d "Prints version information"
