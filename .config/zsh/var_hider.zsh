#!/usr/bin/env zsh
# Hides a bunch of variables in typeset

typeset -H prompt PROMPT PROMPT{2..4} RPROMPT PS{1..4}
typeset -H LS_COLORS ZLS_COLORS
typeset -H colour

noglob typeset -Hm _*
typeset -gHA _ZSH_AUTOSUGGEST_BIND_COUNTS

typeset +x P9K_SSH P9K_TTY
