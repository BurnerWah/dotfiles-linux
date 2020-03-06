#!/usr/bin/env zsh
#
# Hides a bunch of variables in typeset
typeset -H prompt PROMPT PROMPT{2..4} RPROMPT PS{1..4}
typeset -H LS_COLORS ZLS_COLORS
typeset -H colour

# typeset -H __FAST_HIGHLIGHT_TOKEN_TYPES FAST_HIGHLIGHT FAST_HIGHLIGHT_STYLES
# typeset -H fsh__chroma__{main__git,git__aliases}
# typeset -gHA fsh__git__chroma__def

# typeset -H POWERLEVEL9K_VCS_{CLEAN,LOADING,MODIFIED,UNTRACKED}_CONTENT_EXPANSION
# noglob typeset -m -H _POWERLEVEL9K_*
# noglob typeset -m -H _GITSTATUS_*

noglob typeset -Hm _*
typeset -gHA _ZSH_AUTOSUGGEST_BIND_COUNTS

# This one has to be delayed as far as I can tell
# sched +3 'typeset -H _ZSH_AUTOSUGGEST_BIND_COUNTS'
