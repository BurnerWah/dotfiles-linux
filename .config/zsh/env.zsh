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
    # "${HOMEBREW_PREFIX:-$XDG_DATA_HOME/homebrew}/sbin"
    # "${HOMEBREW_PREFIX:-$XDG_DATA_HOME/homebrew}/bin"
  )
  # Remove unwanted elements
  # for element ( "$HOME/bin" ) path[${path[(i)$element]}]=()
}
rehash

# Set core variables {{{1
# things I just don't want in the $HOME folder
export WORKON_HOME=${WORKON_HOME:-$HOME/.var/lib/virtualenv}

# zsh-specific variables
typeset ZSH_AUTOSUGGEST_USE_ASYNC=''

# Set tied variables {{{1
typeset -T XDG_DATA_DIRS xdg_data_dirs
typeset -T INFOPATH infopath

local -TU _VIRTUALENVWRAPPER_API _virtualenvwrapper_api ' '
# This is a hack to prevent the duplicate entries in $_VIRTUALENVWRAPPER_API
# that virtualenvwrapper is prone to adding

# Set $MANPATH {{{2
typeset -U manpath
if (( $+commands[manpath] )) MANPATH="${MANPATH:-"$(manpath)"}"

# Set up $FPATH {{{1
typeset -U fpath
fpath=(
  "$XDG_DATA_HOME/zsh/override-functions"
  $fpath
  "$ZDOTDIR/functions/ZLE"      # ZLE specific functions
  "$ZDOTDIR/functions/Prompts"  # Custom prompts
  "$ZDOTDIR/functions/Misc"     # Stuff
  "$ZDOTDIR/functions/Completion" # Custom completions
  "$XDG_DATA_HOME/zsh/site-functions" # not standard but useful with GNU Stow
  # "${HOMEBREW_PREFIX:-$XDG_DATA_HOME/homebrew}/share/zsh/site-functions"
)

# vim:ft=zsh fdm=marker
