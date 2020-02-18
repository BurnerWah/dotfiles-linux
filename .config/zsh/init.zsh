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

zmodload -aF zsh/curses \
  b:zcurses \
  p:zcurses_{attrs,colors,keycodes,windows} p:ZCURSES_{COLORS,COLOR_PAIRS}
zmodload -aF zsh/datetime \
  b:strftime p:EPOCH{SECONDS,REALTIME} \
  p:epochtime
zmodload -aF zsh/pcre \
  b:pcre_{compile,match,study} \
  C:pcre-match
zmodload -aF zsh/system \
  b:sys{error,read,write,open,seek} b:zsystem \
  f:systell \
  p:errnos p:sysparams

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
bindkey -v


# Interactive variables {{{1
export LS_COLORS="${LS_COLORS:-$(vivid generate burner)}"
if [[ $COLORTERM == "truecolor" ]] local -x MICRO_TRUECOLOR=1


# Early autoloads {{{1
autoload -Uz zstyle+ add-zsh-hook
autoload -Uz zmathfunc && zmathfunc


# Completion system {{{1
autoload -Uz compinit && {
  [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]] && compinit || compinit -C
}

# Compdefs {{{2
noglob compdef _cmp  -P [blx]#zcmp
noglob compdef _diff -P [blx]#zdiff
noglob compdef _less -P [blx]#zless
compdef _make {color,cl}make{,-short}
compdef _xz pxz=xz
compdef _update-alternatives alternatives
noglob compdef _gnu_generic -P {g,gdk,gjs,glib,gst,gtk{[34],doc}#}-*
compdef _gnu_generic \
  daty ml.prevete.Daty \
  ffaudioconverter com.github.Bleuzen.FFaudioConverter \
  file \
  gjs gjs-console \
  picard org.musicbrainz.Picard \
  sysprof sysprof-cli \
  update-desktop-database

# 2}}}

# Main settings
zstyle ':completion:*' auto-description 'specify: %d' # default description template for completions
zstyle ':completion:*' use-cache on                   # Cache complex completions
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/" # Place completion cache in standard folder
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
  '\[' 'aclocal-*' 'automake-*' 'autopep8-*' 'black(|d)-*' ccmake3 \
  chrome-gnome-shell cmake3 cpack3 ctest3 dnf-3 'easy_install-*' 'f2py?##' \
  'flake8-*' 'futurize-*' fzf-tmux genq 'git-*' gnome-keyring-3 gnuplot-qt \
  gpg2 gpgv2 ipdb3 ipython3 'isort-*' 'luajit-*' 'msgfmt?##.py' nodeenv \
  'nu_plugin_*' 'pasteurize-*' pbr-3 'pip(|-)[0-9.]##' printenv 'py[0-9.]##' \
  'pycodestyle-*' 'pycompleter?##' 'pydoc[0-9.]##' 'pyflakes-*' \
  'pygettext?##.py' '(|e)pylint-*' 'pyreverse-*' 'pystache(|-test)-[0-9.]##' \
  'pyvenv-*' sk-tmux 'sphinx-(apidoc|autogen|build|quickstart)-*' 'symilar-*' \
  'trial-*' 'twistd-*' 'vala(|-gen-introspect|c)-[0-9.]##' 'vapigen-*' yum \
  python-argcomplete-check-easy-install-script

zstyle ':completion:*:functions' ignored-patterns \
  '-*' ':chroma/*' '_zsh_(autosuggest|highlight)_*' '_#history[-_]substring[-_]*' \
  '_#p9k_*' '_#gitstatus_*' 'prompt_(^(*_setup))' getColorCode get_icon_names \
  edit-command-line p10k 'powerlevel9k_*' 'powerlevel10k_*' print_icon set_prompt \
  'zsh_math_func_*'

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.1' ignored-patterns \
  'aclocal-*' 'automake-*' 'bashbug-*' 'java-*' 'jjs-*' 'keytool-*' 'orbd-*' \
  'pack200-*' 'policytool-*' 'rmid-*' 'rmiregistry-*' 'servertool-*' \
  'tnameserv-*' 'unpack200-*'


zstyle ':completion:*:parameters' ignored-patterns \
  '_#POWERLEVEL9K_*' '_#p9k_*' '_#P9K_*' '_#GITSTATUS_*' '_#ZSH_AUTOSUGGEST_*' \
  '_#ZSH_HIGHLIGHT_*' '_#_#FAST_*' '_#_#fast_*' 'HISTORY_SUBSTRING_SEARCH_*' \
  '_history_substring_search_*'

zstyle ':completion:*:styles' ignored-patterns ':zle:(autosuggest|orig)-*'

zstyle ':completion:*:user-math-functions' ignored-patterns fsh_sy_h_append

zstyle ':completion:*:widgets' ignored-patterns '(autosuggest|orig)-*'


# Everything else
zstyle ':completion:*:-DISPLAY-:*:hosts' command :
zstyle ':completion:*:-DISPLAY-:*:hosts' use-ip

zstyle ':completion:*:cdr:*:*' menu selection
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS' '(*/)#.git' # Ignore VCS folders

zstyle ':completion:*:docker*:*' menu selection
zstyle ':completion:*:docker*:*' option-stacking yes

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

zstyle ':completion:*:git*:*:commits'      list-colors '=(#b)([[:xdigit:]]#)  -- \[([^\]]#)\]*=0=01;33=00;34'
zstyle ':completion:*:git*:*:heads(|-remote|-local)' list-colors '=(#b)([[:ascii:]]##)*=0=0;35'

zstyle ':completion:*:git-add:*:*-files' menu interactive

# TODO: Add more colors to kill completions
zstyle ':completion:*:kill:*:processes' list-colors \
  '=(#b) #([[:digit:]]#) #([[:digit:]]#.[[:digit:]]#)*=0=01;31=01;32'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:task:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:tmux:*:subcommands' mode 'commands'
zstyle ':completion:*:tmux:*:subcommands' ignored-patterns \
  'choose-*' 'confirm-before' 'find-window'


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
zstyle ':ztodo:*'    cache-file ~/.local/share/zsh/ztodolist
zstyle ':stick-note' notefile ~/.local/share/zsh/zsticky
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
if (( $+commands[z.lua] )) eval "$(z.lua --init zsh enhanced once)"
if (( $+commands[direnv] )) eval "$(direnv hook zsh)"
#autoload -Uz abbrev-alias && abbrev-alias --init


# Autoloads {{{1
autoload -Uz zcalc
autoload -Uz run-help run-help-{dnf,git,ip,openssl,p4,sudo,svk,svn}
unalias run-help
alias help=run-help
autoload -Uz zshTimedRehash && zshTimedRehash # Runs rehash every ten minutes
autoload -Uz harden # convert a symbolic link to a file
autoload -Uz silent # run program in background


# }}}

zstyle ':zle:cd-widget:colors' disabled false

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/ZLE.zsh

if [[ "$options[interactive]" == on ]] source $ZDOTDIR/var_hider.zsh

# User dirs
local -Hhr \
  cargo=~/.local/lib64/cargo \
  flatpak=/var/lib/flatpak \
  golang=~/.local/lib64/golang \
  lutris=~/.local/share/lutris \
  retroarch=~/.var/app/org.libretro.RetroArch/config/retroarch \
  steam=~/.local/share/Steam \
  zealdocs=~/.var/app/org.zealdocs.Zeal/data/Zeal/Zeal/docsets

: ~cargo ~flatpak ~golang ~lutris ~retroarch ~steam ~zealdocs

# vim:ft=zsh fdm=marker
