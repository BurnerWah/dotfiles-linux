#!/usr/bin/zsh
# init.zsh (.zshrc)
# sourced in interactive sessions
autoload -Uz zrecompile

source $ZDOTDIR/profile.zsh # /etc/profile.d/ files are sourced on startup bit this is missed
source $ZDOTDIR/.terminfo.zsh


# Modules {{{1
zmodload zsh/mathfunc

zmodload -aF zsh/attr       b:z{get,set,del,list}attr
zmodload -aF zsh/cap        b:{,get,set}cap
zmodload -aF zsh/clone      b:clone
zmodload -aF zsh/net/socket b:zsocket
zmodload -aF zsh/net/tcp    b:ztcp
zmodload -aF zsh/zpty       b:zpty
zmodload -aF zsh/zselect    b:zselect
zmodload -aF zsh/mapfile    p:mapfile

[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
# nearcolor fixes colors but it's not always present or needed


# Zsh options {{{1
HISTFILE=~/.local/share/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_GLOB
setopt NOTIFY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt COMPLETE_IN_WORD
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
#setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt NO_BEEP
setopt REMATCH_PCRE
setopt CSH_JUNKIE_LOOPS # fuck you this is better
bindkey -v


# Interactive variables {{{1
export LS_COLORS="${LS_COLORS:-$(vivid generate burner)}"

if [[ $COLORTERM == "truecolor" ]] local -x MICRO_TRUECOLOR=1

export FZF_DEFAULT_COMMAND='fd -tf'


# Early autoloads {{{1
autoload -Uz zstyle+ add-zsh-hook
autoload -Uz zmathfunc && zmathfunc


# Completion system {{{1
autoload -Uz compinit && {
  [[ -n $ZDOTDIR/.zcompdump(#qN.mh+168) ]] && compinit || compinit -C
}

# Compdefs {{{2
noglob compdef _cmp  -P [blx]#zcmp
noglob compdef _diff -P [blx]#zdiff
noglob compdef _less -P [blx]#zless
compdef _xz pxz=xz
compdef _update-alternatives alternatives

# 2}}}

# Main settings
zstyle ':completion:*' auto-description 'specify: %d'
# default description template for completions
zstyle ':completion:*' use-cache on
# Cache complex completions
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/"
# Place completion cache in standard folder
zstyle ':completion:*' completer _complete _match _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true


# Tags
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:commands' ignored-patterns \
  'cargo-*' 'git-*'

zstyle ':completion:*:functions' ignored-patterns '-*' ':chroma/*' '_*' 'prompt_*' 'zsh_math_func_*'

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.1' ignored-patterns \
  'aclocal-*' 'automake-*' 'bashbug-*' 'java-*' 'jjs-*' 'keytool-*' 'orbd-*' \
  'pack200-*' 'policytool-*' 'rmid-*' 'rmiregistry-*' 'servertool-*' \
  'tnameserv-*' 'unpack200-*'


zstyle ':completion:*:parameters' ignored-patterns \
  '(#i)_#p(|owerlevel)<->k*' '_#GITSTATUS_*' '_#ZSH_AUTOSUGGEST_*' \
  '_#ZSH_HIGHLIGHT_*' '(#i)_#fast_*' '(#i)_#history_substring_search_*'

zstyle ':completion:*:styles' ignored-patterns ':zle:(autosuggest|orig)-*'

zstyle ':completion:*:users' ignored-patterns \
  bin daemon sync shutdown halt games nobody operator

zstyle ':completion:*:user-math-functions' ignored-patterns fsh_sy_h_append

zstyle ':completion:*:widgets' ignored-patterns '(autosuggest|orig)-*'


# Special contexts
zstyle ':completion:*:-tilde-:*:users' ignored-patterns \
  $(rg '^(.+?):.*:/(?:s?bin|dev/null)?:[^:]+$' -r '$1' /etc/passwd)
# filter out stuff that it's useless to access via ~user

# Everything else
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

zstyle ':completion:*:-DISPLAY-:*:hosts' command :
zstyle ':completion:*:-DISPLAY-:*:hosts' use-ip

zstyle ':completion:*:cdr:*:*' menu selection

zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS' '(*/)#.git'
# Ignore VCS folders

zstyle ':completion:*:fd:*:options' ignored-patterns --maxdepth --search-path -u

zstyle ':completion:*:git*:*' use-fallback false
zstyle ':completion:*:git:*' verbose true
zstyle ':completion:*:git*:*' menu selection

() {
  local remove=(
    authors bug changelog clang-format coauthor contrib count create-branch
    delete-branch delete-submodule delete-tag effort extras feature flow graft
    guilt ignore ignore-io merge-into missing psykorebase refactor squash stamp
    standup undo
  )
  zstyle ':completion:*:git:*' user-commands ${${${(M)${(k)commands}:#git-*}/git-/}:|remove}
}

zstyle ':completion:*:git*:*:commits' list-colors '=(#b)([0-9a-f]#)  -- \[([^\]]#)\]*=0=01;33=00;34'
zstyle ':completion:*:git*:*:heads(|-remote|-local)' list-colors '=(#b)([[:ascii:]]##)*=0=0;35'

zstyle ':completion:*:git-add:*:*-files' menu interactive

zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) #([0-9]#.[0-9]#)*=0=01;31=01;32'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:rm:*' file-patterns '*:all-files'

zstyle ':completion:*:task:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:su:*:users' ignored-patterns \
  $(rg '^(.+?):.*:/sbin/nologin$' -r '$1' /etc/passwd)
# Filter out users we can't log into

# Source key database {{{1
if [[ -e $ZDOTDIR/.zkbd/${TERM}-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]] {
  source $ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
}


# Terminal title {{{1
autoload -Uz terminal_title_{preexec,precmd}
add-zsh-hook precmd terminal_title_precmd
add-zsh-hook preexec terminal_title_preexec


# Prompt setup {{{1
autoload -Uz promptinit && promptinit
prompt powerlevel10k
zrecompile $ZDOTDIR/.p10k.zsh; source $ZDOTDIR/.p10k.zsh


# Settings {{{1
zstyle ':chpwd:*'    recent-dirs-file ~/.local/share/zsh/chpwd-recent-dirs


# Plugins {{{1
() {
  # This just loads recompiles & loads plugins.
  local plugin
  local plugin_dir="$HOME/.local/share/zsh/plugins"
  local plugins=(
    'zsh-autosuggestions'
    'zsh-history-substring-search'
    'fast-syntax-highlighting.plugin'
  )
  for plugin in $plugins; do
    zrecompile $plugin_dir/**/$plugin.zsh
    source $plugin_dir/**/$plugin.zsh
  done
}
if (( $+commands[zoxide] )) eval "$(zoxide init zsh)"
if (( $+commands[broot] )) eval "$(broot --print-shell-function zsh)"


# Autoloads {{{1
autoload -Uz zcalc run-help run-help-{dnf,git,ip,openssl,p4,sudo,svk,svn} silent
unalias run-help
alias help=run-help
autoload -Uz zshTimedRehash && zshTimedRehash # Runs rehash every ten minutes

# }}}

zstyle ':zle:cd-widget:colors' disabled false

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/ZLE.zsh

if [[ "$options[interactive]" == on ]] source $ZDOTDIR/var_hider.zsh

# vim:ft=zsh fdm=marker
