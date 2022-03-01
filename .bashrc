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

HISTFILE=~/.cache/bash_history

# shellcheck disable=1090
# source ~/.local/share/bash-completion/completions/*

# shellcheck source=/dev/null
if type -f zoxide >/dev/null 2>&1; then
  source <(zoxide init bash 2>/dev/null)
fi

# User specific aliases and functions
if type -f exa >/dev/null 2>&1; then
  alias ls=exa
  alias ll='ls -l'
  alias la='ll -a'
fi

# Variable cleanup
if type -f fzf >/dev/null 2>&1; then
  for i in $(printenv | rg _fzf_orig_completion_ | sed -E 's/^(_fzf_orig_completion_[^=]+)(=.*)$/\1/g'); do
    export -n "${i?}"
  done
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
