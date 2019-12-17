#!/usr/bin/env bash

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ $HOME/.local/bin: ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

HISTFILE=~/.local/share/bash_history

source ~/.local/share/bash-completion/completions/*

# User specific aliases and functions
alias ls=exa
alias ll='ls -l'
alias la='ll -a'
