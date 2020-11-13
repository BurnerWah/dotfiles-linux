if (( $+aliases[which] )) unalias which # There's a file fedora comes with that screws up the which builtin
if [[ "$XDG_CURRENT_DESKTOP" == gnome ]] xrdb -merge ~/.Xdefaults

for element ( "$HOME/bin" "$HOME/.dotnet/tools" ) path[${path[(i)$element]}]=()

unset HISTCONTROL
unset HISTSIZE
# vim:ft=zsh fdm=marker
