# Due to how winetricks is designed (as one 20k line portable shell script),
# it's really difficult to even come up with good completion scripts. The best
# that can be done is grepping for verb metadata, and even then we don't get
# descriptions since they're on different lines.

function __winetricks_verbs
    cat (which winetricks) | string match -r 'w_metadata\s+\S+' | string replace -r 'w_metadata\s+(\S+)' '$1'
end

complete -c winetricks -xa "(__winetricks_verbs)"
