#!/usr/bin/env zsh
#
# ZLE Settings
# Pre-setup {{{1
key[Tab]='^I'
key[Esc]='\e'
key[Alt]='^['

# Function loading {{{1
autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz sticky-note       && zle -N sticky-note

autoload -Uz surround && {
  zle -N delete-surround surround
  zle -N add-surround    surround
  zle -N change-surround surround
}

zle -N redraw-prompt __ZLE_redraw_prompt__
zle -N quit __ZLE_CMD_quit__ && zle -A quit q


# Keybindings: {{{1
# INSERT {{{2
bindkey -M viins "${key[Up]}"     history-substring-search-up
bindkey -M viins "${key[Down]}"   history-substring-search-down
bindkey -M viins "${key[Tab]}"    complete-word  # normal tab completion
bindkey -M viins "${key[Delete]}" vi-delete-char
bindkey -M viins "${key[Home]}"   vi-beginning-of-line
bindkey -M viins "${key[End]}"    vi-end-of-line
# NORMAL {{{2
bindkey -M vicmd ZZ quit   # That's a thing you can do in vim
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround

# vim:fenc=utf-8 ft=zsh fdm=marker
