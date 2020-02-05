#!/usr/bin/zsh

source $HOME/.config/user-dirs.dirs

# Set up $PATH {{{1
# My main priority here is having a clean and stable $PATH. Elements stay in
# place, and unnecessary directories are omitted.
typeset -U path
() {
  local element
  # Prepend elements that aren't already in $PATH
  for element ( "$HOME/.local/bin" ) {
    if ! (( ${path[(Ie)$element]} )) path=("$element" $path)
  }
  # Append elements
  path+=(
    "${FLATPAK_SYSTEM_DIR:-/var/lib/flatpak}/exports/bin"
  )
  # Remove unwanted elements
  for element ( "$HOME/bin" ) path[${path[(i)$element]}]=()
}
rehash

# Set core variables {{{1
# Command vars
# page uses neovim as a pager. It's really good
export PAGER=${PAGER:-page}
export MANPAGER="page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'"

export FZF_DEFAULT_COMMAND='fd -t f'

# things I just don't want in the $HOME folder
export WORKON_HOME=${WORKON_HOME:-$HOME/.var/lib/virtualenv}

# zsh-specific variables
typeset ZSH_AUTOSUGGEST_USE_ASYNC=''

# Set tied variables {{{1
typeset -T XDG_DATA_DIRS xdg_data_dirs
typeset -T INFOPATH infopath

# Set $MANPATH {{{2
typeset -U manpath
if (( $+commands[manpath] )) MANPATH="${MANPATH:-"$(manpath)"}"

# Set up $FPATH {{{1
typeset -U fpath
fpath+=(
  "$ZDOTDIR/functions/ZLE"      # ZLE specific functions
  "$ZDOTDIR/functions/Prompts"  # Custom prompts
  "$ZDOTDIR/functions/Misc"     # Stuff
  "$ZDOTDIR/functions/Completion" # Custom completions
  "$XDG_DATA_HOME/zsh/site-functions" # not standard but useful with GNU Stow
)

# Fix Kitty's bad terminfo {{{1
if [[ "$TERMINFO" == "/usr/lib64/kitty/terminfo" \
   && -d "$XDG_DATA_HOME/terminfo" ]] \
   export TERMINFO="$XDG_DATA_HOME/terminfo"

# vim:ft=zsh fdm=marker
