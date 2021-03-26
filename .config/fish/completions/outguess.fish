# outguess(1) - stenography tool
# NOTE outguess doesn't have any long options at all
# NOTE some of the capital options could be wrong
# NOTE -F is weird
complete -xc outguess -s s -d "Iteration start"
complete -xc outguess -s S -d "Iteration start (2nd data set)"
complete -xc outguess -s i -d "Iteration limit"
complete -xc outguess -s I -d "Iteration limit (2nd data set)"
complete -xc outguess -s k -d Key
complete -xc outguess -s K -d "Key (2nd data set)"
complete -xc outguess -s d -d "Filename of dataset"
complete -xc outguess -s D -d "Filename of dataset 2"
complete -c outguess -s e -d "Use error correcting encoding"
complete -c outguess -s E -d "Use error correcting encoding (2nd data set)"
complete -xc outguess -s p -d "Parameter passed to destination data handler"
complete -c outguess -s r -d "Retrieve message from data"
complete -xc outguess -s x -d "Number of key derivations to be tried"
complete -c outguess -s m -d "Mark pixels that have been modified"
complete -c outguess -s t -d "Collect statistics about redundant bit usage"
complete -c outguess -o F+ -d "Enable statistical steganalysis foiling (default)"
complete -c outguess -o F- -d "Disable statistical steganalysis foiling"
