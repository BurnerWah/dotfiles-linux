if [[ -n "$GNOME_TERMINAL_SCREEN" ]] {
  case $TERM {
    (gnome*) : ;;
    (xterm-256color) export TERM=gnome-256color ;;
    (xterm) export TERM=gnome ;;
  }
}
