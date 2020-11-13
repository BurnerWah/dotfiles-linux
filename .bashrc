#!/usr/bin/env bash

# Source global definitions
if [ -f /etc/bashrc ]; then
  # shellcheck disable=1091
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

# shellcheck source=/dev/null
source <(zoxide init bash 2>/dev/null)

# User specific aliases and functions
if type -f exa >/dev/null 2>&1; then
  alias ls=exa
  alias ll='ls -l'
  alias la='ll -a'
fi

# toolbox-specific stuff
if [ -f /run/.containerenv ] && [ -f /run/.toolboxenv ]; then
  # This lets us run toolbox in kitty
  if [[ -z "$TERMINFO_DIRS" ]]; then
    TERMINFO_DIRS="/usr/local/share/terminfo:/usr/share/terminfo"
  fi
  if ! [[ "$TERMINFO_DIRS" =~ $HOME/.local/share/terminfo ]]; then
    TERMINFO_DIRS="$HOME/.local/share/terminfo:$TERMINFO_DIRS"
  fi
  export TERMINFO_DIRS
fi
