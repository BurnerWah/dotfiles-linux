#!/usr/bin/zsh
# vim ft=zsh fdm=marker

export GOBIN="$HOME/.local/bin"

# Some stuff we need to do beforehand {{{1
source $HOME/.config/user-dirs.dirs
function getBestCommand() {
  local finalCommand
  while [[ -z $finalCommand && -n $1 ]]; do
    finalCommand=${commands[(i)${1}]}
    shift
  done
  echo -n $finalCommand
}

# Add user folders to $PATH {{{1
() {
  local -a path_prepends=(
    "$HOME/.local/bin"
  ) path_appends=(
    "${FLATPAK_SYSTEM_DIR:-/var/lib/flatpak}/exports/bin"
  )
  local element
  for element in $path_prepends; do
    if ! (( ${path[(Ie)$element]} )) { path=($element $path) }
  done
  for element in $path_appends; do
    if ! (( ${path[(Ie)$element]} )) { path+=$element }
  done
  path[$path[(i)$HOME/bin]]=()
  export PATH
}
rehash

# Set core variables {{{1
# Use the getBestCommand function to get, well, the best available command.

# Command vars
# Generally we want to prefer more deliberately installed programs.
# So, something that has to be built from source should come before something manually installed,
# both of which should come before things that might be pre-installed.
export EDITOR=${EDITOR:-nvim} # set editor to use while in terminal
# page uses NeoVim as a pager. It's really good
export PAGER=${PAGER:-page}
export MANPAGER="page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'"

export FZF_DEFAULT_COMMAND='fd --type f'


# config dirs/files
#() {
#  setopt EXTENDED_GLOB
#  local -a rocks_versions=(/usr/lib64/luarocks/rocks-*(/))
#  local version
#  for version in (${(M)${rocks_versions}/\/usr\/lib64\/luarocks\/rocks-/}); do
#    export LUAROCKS_CONFIG_${version/./_}=${LUAROCKS_CONFIG_${version/./_}:-${XDG_CONFIG_HOME:-$HOME/.config}/luarocks/config-${version}.lua}
#  done
#}
export LUAROCKS_CONFIG_5_3=${LUAROCKS_CONFIG_5_3:-${XDG_CONFIG_HOME:-$HOME/.config}/luarocks/config-5.3.lua}

# things I just don't want in the $HOME folder
export WORKON_HOME=${WORKON_HOME:-$HOME/.var/lib/virtualenv}

# zsh-specific variables
typeset ZSH_AUTOSUGGEST_USE_ASYNC=''

# Set tied variables {{{1
typeset -T INFOPATH infopath=(
  "$HOME/.local/share/info"
  "/usr/local/share/info"
  "/usr/share/info"
)
typeset -T XDG_DATA_DIRS xdg_data_dirs

# Set $MANPATH {{{1
manpath=(
  "$HOME/.local/share/man"
  "/usr/local/share/man"
  "/usr/share/man"
)

# Add user folders to $FPATH {{{1
() {
  local -a fpath_prepends=(
    "$HOME/.local/share/zsh/site-functions" # not standard but useful with GNU Stow
    "$ZDOTDIR/functions/Completion/Patched" # intended to shadow official completions
  ) fpath_appends=(
    "$ZDOTDIR/functions/Zle"      # ZLE specific functions
    "$ZDOTDIR/functions/Prompts"  # Custom prompts
    "$ZDOTDIR/functions/Plugins"  # Autoloading plugins
    "$ZDOTDIR/functions/Misc"     # Stuff
    "$ZDOTDIR/functions/Help"
    "$ZDOTDIR/functions/Internals"  # Library of autoloading functions I've written for other functions to use
    "$ZDOTDIR/functions/Completion/Core"  # Stuff used by my own completion functions
    "$ZDOTDIR/functions/Completion"       # Custom and` third-party completions
  )
  local element
  for element in $fpath_prepends; do
    if ! (( ${fpath[(Ie)$element]} )) {fpath=($element $fpath)}
  done
  for element in $fpath_appends; do
    if ! (( ${fpath[(Ie)$element]} )) { fpath+=$element }
  done
}

# Source files in zshenv.d {{{1
if [[ -d $ZDOTDIR/env.d ]]; then
  for i in $ZDOTDIR/env.d/*.*sh ; do
    if [ "${-#*i}" != "$-" ]; then
      source "$i"
    else
      source "$i" >/dev/null
    fi
  done
fi
