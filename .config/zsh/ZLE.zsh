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

zle -N rationalize-dot __ZLE_rationalize_dot__
zle -N fzf-zlua __ZLE_fzf_zlua__
zle -N fzf-cd __ZLE_fzf_cd__
zle -N fzf-hist __ZLE_fzf_history__

zle -N quit __ZLE_CMD_quit__ && zle -A quit q
zle -N fuck __ZLE_CMD_fuck__

zle -N _Ctrl+z __ZLE_map_ctrl+z__

# Keybindings: {{{1
# INSERT {{{2
bindkey -M viins "${key[Up]}"     history-substring-search-up
bindkey -M viins "${key[Down]}"   history-substring-search-down
bindkey -M viins "${key[Tab]}"    complete-word  # normal tab completion
bindkey -M viins "${key[Delete]}" vi-delete-char
bindkey -M viins "${key[Home]}"   vi-beginning-of-line
bindkey -M viins "${key[End]}"    vi-end-of-line
bindkey -M viins '^[c'  fzf-cd # cd to a subdirectory
bindkey -M viins '^[z'  fzf-zlua  # jump to a folder using z.lua
bindkey -M viins '^R'   fzf-hist  # input a command from shell's history
bindkey -M viins '^Z'   _Ctrl+z
bindkey -M viins '\E\E' fuck  # fix last command
# bindkey -M viins . rationalize-dot
# NORMAL {{{2
# bindkey -M vicmd su widget/sudo # rerun last command as root
bindkey -M vicmd \! edit-command-line # modify the command being input in $EDITOR
bindkey -M vicmd ZZ quit   # That's a thing you can do in vim
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround

# vim:fenc=utf-8 ft=zsh fdm=marker
