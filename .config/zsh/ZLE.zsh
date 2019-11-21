#!/usr/bin/env zsh
#
# ZLE Settings
# Pre-setup {{{1
key[Tab]='^I'
key[Esc]='\e'
key[Alt]='^['

# Function loading {{{1
autoload -Uz lib/redraw-prompt && zle -N zle::Prompt.Redraw lib/redraw-prompt

autoload -Uz widget/cd         && zle -N widget::cd widget/cd
autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz widget/ctrl-z     && zle -N widget::CTRL-Z widget/ctrl-z
autoload -Uz grep2awk          && zle -N grep2awk
autoload -Uz widget/history    && zle -N widget::hist widget/history
autoload -Uz widget/z          && zle -N widget::z widget/z
autoload -Uz sticky-note       && zle -N sticky-note

autoload -Uz surround && {
  zle -N delete-surround surround
  zle -N add-surround    surround
  zle -N change-surround surround
}

autoload -Uz widget/vim-quit && { zle -N quit widget/vim-quit && zle -A quit q } # quit like vim

autoload -Uz widget/fuck && zle -N fuck widget/fuck

# Keybindings: {{{1
# INSERT {{{2
bindkey -M viins "${key[Up]}"     history-substring-search-up
bindkey -M viins "${key[Down]}"   history-substring-search-down
bindkey -M viins "${key[Tab]}"    complete-word  # normal tab completion
bindkey -M viins "${key[Delete]}" vi-delete-char
bindkey -M viins "${key[Home]}"   vi-beginning-of-line
bindkey -M viins "${key[End]}"    vi-end-of-line
bindkey -M viins '^[c'  widget::cd # cd to a subdirectory
bindkey -M viins '^[z'  widget::z  # jump to a folder using z.lua
bindkey -M viins '^R'   widget::hist  # input a command from shell's history
bindkey -M viins '^Z'   widget::CTRL-Z
bindkey -M viins '\E\E' fuck  # fix last command
# NORMAL {{{2
bindkey -M vicmd su widget/sudo # rerun last command as root
bindkey -M vicmd \! edit-command-line # modify the command being input in $EDITOR
bindkey -M vicmd ZZ quit   # That's a thing you can do in vim
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround

# vim:fenc=utf-8 ft=zsh fdm=marker
