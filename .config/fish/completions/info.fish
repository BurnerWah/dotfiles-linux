# info completion
#
# Issues:
# * Info pages lack descriptions
#   There's a lot of reasons for this.
#   The biggest one is just that the output of `info -o-` and info's dir files
#   aren't the most machine readable. There's a lot of variance in what we can
#   see, and honestly without a complicated scripted solution it's probably get
#   descriptions.
#   Entries can vary based on their title, page name, section name, description
#   length, and I think something else but I'm genuinely not sure what.
#   I was able to find 10 variants on my system which is too many to parse.
#
# ignored arguments
# --debug -x - weird
# --dribble - probably not needed
# --no-raw-escapes - lazy
# --raw-escapes -R - lazy
# --restore - probably not needed
# --(no-)show-malformed-multibytes - lazy
# --speech-friendly -b - windows only
# --strict-node-location - not needed

function __info_pages
    command info -o- | string match -r '^\* [^:]+: \([^)]+\).+' | string replace -r '^\* [^:]+: \((.+?)\).*' '$1'
    # command info -o- |\
    #    string match -r '^(\* [^:]+: \(.*|\s{32}.+)' |\
    #    uniq |\
    #    string trim |\
    #    string join ' ' |\
    #    string split ' * '
end

complete -c info -xa "(__info_pages)"

complete -c info -s a -l all -d "Use all matching manuals"
complete -xc info -s k -l apropos -d "Look up STRING in all indices of all manuals"
complete -xc info -s d -l directory -d "Add DIR to INFOPATH" -a "(__fish_complete_directories)"
complete -Fc info -s f -l file -d "Specify Info manual to visit"
complete -c info -s h -l help -d "Display this help and exit"
complete -xc info -l index-search -d "Go to node pointed by index entry STRING"
complete -xc info -s n -l node -d "Specify nodes in first visited Info file"
complete -Fc info -s o -l output -d "Output selected nodes to FILE"
complete -c info -s O -l show-options -l usage -d "Go to command-line options node"
complete -c info -l subnodes -d "Recursively output menu items"
complete -xc info -s v -l variable -d "Assign VALUE to Info variable VAR"
complete -c info -l version -d "Display version & exit"
complete -c info -s w -l where -l location -d "Print physical location of Info file"
complete -Fc info -l init-file -d "Init file to use instead of ~/.infokey"
complete -c info -l vi-keys -d "Enable vi-like keybindings"
