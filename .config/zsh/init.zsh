#!/usr/bin/zsh
# vim:ft=zsh:fdm=marker
# init.zsh (.zshrc)
# sourced in interactive sessions
autoload -Uz zrecompile

source $ZDOTDIR/.terminfo.zsh
# Modules {{{1
# Notes {{{2
# Modules that MUST be autoloaded
# * zsh/main    - pseudo-module that contains zsh itself
# * zsh/rlimits - not listed as an actual module, likely a part of zsh-core
#
# Modules set to autoload by default
# * zsh/sched         - scheduling
# * zsh/param/private - private variables
# * zsh/parameter     - special array with access to internal hash tables
# * zsh/termcap       - access to termcap
# * zsh/terminfo      - access to terminfo
# * zsh/zutil         - utility builtins
# * zsh/compctl       - compsys: legacy controller command
# * zsh/complete      - compsys: core
# * zsh/complist      - compsys: file listings
# * zsh/computil      - compsys: stuff needed for function based completions
# * zsh/zle           - ZLE: core
# * zsh/zleparameter  - ZLE: internals
#
# Modules that SHOULD NOT usually be autoloaded
# * zsh/files     - builtins will shadow coreutils
# * zsh/stat      - builtins will shadow coreutils
# * zsh/nearcolor - only needed on terminals without truecolor support
# * zsh/zprof     - only needed when profiling zsh
# * zsh/newuser   - only needed for brand new users
# * zsh/example   - not needed 99% of the time
# 2}}}

zmodload -ab zsh/attr z{get,set,del,list}attr # builtins for manipulating xattr
#zmodload zsh/cap        # POSIX.1e (POSIX.6)
zmodload -ab zsh/cap {,get,set}cap
#zmodload zsh/clone      # Clone current terminal to another tty
zmodload -ab zsh/clone clone
zmodload zsh/curses     # ncurses stuff
zmodload zsh/datetime   # check the current date
#zmodload zsh/langinfo   # array of locale information
zmodload zsh/mapfile    # special array containing external files
zmodload zsh/mathfunc   # maths
zmodload zsh/net/socket # local network interactions
zmodload zsh/net/tcp    # external network interactions
zmodload zsh/pcre       # Perl compatible regex
zmodload zsh/regex      # regex matching conditions
zmodload zsh/system     # I forgot
zmodload zsh/zftp       # ftp support
zmodload zsh/zpty       # pseudo-terminals
zmodload zsh/zselect    # forgot again

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
bindkey -v
# Interactive variables {{{1
#eval "$(dircolors)"
export LS_COLORS="${LS_COLORS:-$(vivid generate burner)}"
if [[ $COLORTERM == "truecolor" ]] export MICRO_TRUECOLOR=1
#export GREP_COLORS="${GREP_COLORS:-$(vivid -d ~/.config/vivid/filetypes.grep.yml generate burner)}"
#export EXA_COLORS="${EXA_COLORS:-$(vivid -m 8-bit generate molokai)}"
# Early autoloads {{{1
autoload -Uz zstyle+ add-zsh-hook
autoload -Uz zmathfunc && zmathfunc
# Completion system {{{1
# NOTES {{{2
# Zsh has a very powerful completion system, which I use a lot. This section
# is where the majority of my zstyle settings are.
#
# zstyle is basically a lightweight configuration system for zsh. It's not
# perfect, but it does well enough.
# 2}}}
#zstyle ':compinstall' filename '/home/jadenpleasants/.config/zsh/init.zsh'
autoload -Uz compinit && {
  [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]] && compinit || compinit -C
}

# Bash completions {{{2
#autoload -Uz bashcompinit && { bashcompinit && {
#  BASH_VERSION=5 source /usr/share/bash-completion/completions/gdbus
#  BASH_VERSION=5 source /usr/share/bash-completion/completions/gapplication
#  BASH_VERSION=5 source /usr/share/bash-completion/completions/gio
#  BASH_VERSION=5 source /usr/share/bash-completion/completions/dconf-editor
#  BASH_VERSION=5 source /usr/share/bash-completion/completions/gresource
#  for i in \
#    addpart blkdiscard blkid blkzone blockdev bodhi cfdisk chcpu chmem col \
#    colcrt colormgr colrm createrepo_c ctrlaltdel delpart eject fallocate \
#    fdformat fdisk fincore findfs findmnt flock fsck fsck.{cramfs,minix} \
#    fsfreeze fstrim gnome-control-center gnome-mplayer hwclock ipcmk ipcrm \
#    ipcs isosize kmod ldattach logger losetup lscpu lsipc lslocks lslogins \
#    lsmem lsns mcookie mesg mkfs mkfs.{cramfs,minix} mkswap mokutil more \
#    mountpoint namei ndctl nsenter partx prlimit raw readprofile resizepart \
#    rev rpmlint rpm-ostree rtcwake semanage setarch setpriv setsebool setterm \
#    sfdisk source-highlight swaplabel swapoff swapon taskset ul unshare \
#    utmpdump uuidgen uuidparse virt-{clone,convert,install,xml} \
#    wall wdctl zramctl \
#    ; {
#      if ! (( $+_comps[$i] )) && [[ -a /usr/share/bash-completion/completions/$i ]]
#        source /usr/share/bash-completion/completions/$i
#    }
#}}

# Eval completion {{{2
# Note on kubectl {{{3
# kubectl has the worst goddamn completions I've ever seen.
# Like, really, who on earth thought they were acceptable?
# Startup time:
#   W/  kubectl completions: 621.5 ms ± 21.9 ms
#   W/O kubectl completions: 204.7 ms ± 13.3 ms
# Difference is approx 400 ms, which is a fucking joke.
# Maybe it's designed to use a million threads.
# Maybe it's the most complicated compdef in history.
# Or maybe it has hundreds of lines of "var+=(thing)" in place of "var+=(thing1 thing2 etc...)"
# Maybe it converts bash completions to zsh completions using sed.
# Maybe, it's just shit.
#
#
# Probably that last one.
# 3}}}
if (( $+commands[kompose] )); then
  source <(kompose completion zsh) # 37.7 ms ± 5.6 ms
fi
# }}}
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

zstyle ':completion:*' auto-description 'specify: %d' # default description template for completions
zstyle ':completion:*' use-cache on                   # Cache complex completions
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/" # Place completion cache in standard folder
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:parameters' ignored-patterns \
  '_#POWERLEVEL9K_*' '_#p9k_*' '_#P9K_*' '_#GITSTATUS_*' '_#ZSH_AUTOSUGGEST_*' \
  '_#ZSH_HIGHLIGHT_*'

zstyle ':completion:*:*:-DISPLAY-:*:hosts' command :
zstyle ':completion:*:*:-DISPLAY-:*:hosts' use-ip

zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS' '(*/)#.git' # Ignore VCS folders

# TODO: Add colors to docker completions
zstyle ':completion:*:*:docker*:*' menu selection
zstyle ':completion:*:*:docker*:*' option-stacking yes

zstyle ':completion:*:*:git*:*' use-fallback false
zstyle ':completion:*:*:git:*' verbose true
zstyle ':completion:*:*:git*:*:*' menu selection

() {
  local remove=(
    authors bug changelog clang-format coauthor contrib count create-branch
    delete-branch delete-submodule delete-tag effort extras feature flow graft
    guilt ignore ignore-io merge-into missing psykorebase refactor squash stamp
    standup undo
  )
  zstyle ':completion:*:*:git:*' user-commands ${${${(M)${(k)commands}:#git-*}/git-/}:|remove}
}

zstyle ':completion:*:*:git*:*:commits'      list-colors '=(#b)([[:xdigit:]]#)  -- \[([^\]]#)\]*=0=01;33=00;34'
zstyle ':completion:*:*:git*:*:heads-remote' list-colors '=(#b)([[:ascii:]]##)*=0=0;35'

# TODO: Add more colors to kill completions
zstyle ':completion:*:*:kill:*:processes' list-colors \
  '=(#b) #([[:digit:]]#) #([[:digit:]]#.[[:digit:]]#)*=0=01;31=01;32'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:*:tmux:*:subcommands' mode 'commands'
zstyle ':completion:*:*:tmux:*:subcommands' ignored-patterns \
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
#prompt powerlevel10k
#source $ZDOTDIR/.p10k.zsh
#prompt starship
prompt powerlevel10k
zrecompile $ZDOTDIR/.p10k.zsh; source $ZDOTDIR/.p10k.zsh

# Settings {{{1
zstyle ':ztodo:*'    cache-file ~/.local/share/zsh/ztodolist
zstyle ':stick-note' notefile ~/.local/share/zsh/zsticky
zstyle ':chpwd:*'    recent-dirs-file ~/.local/share/zsh/chpwd-recent-dirs

# Plugins {{{1

source $ZDOTDIR/**/zsh-autosuggestions.zsh
source $ZDOTDIR/**/zsh-history-substring-search.zsh
source $ZDOTDIR/**/fast-syntax-highlighting.plugin.zsh
#source $ZDOTDIR/**/autopair.zsh
if (( $+commands[z.lua] )) eval "$(z.lua --init zsh enhanced once)"
if (( $+commands[direnv] )) eval "$(direnv hook zsh)"
#autoload -Uz abbrev-alias && abbrev-alias --init


# Autoloads {{{1
autoload -Uz zcalc
autoload -Uz run-help run-help-{dnf,git,ip,openssl,p4,sudo,svk,svn}
unalias run-help
alias help=run-help
autoload -Uz zshTimedRehash && zshTimedRehash # Runs rehash every ten minutes
autoload -Uz xman xinfo # helper scripts to open documentation in Gnome Help
autoload -Uz harden # convert a symbolic link to a file
# }}}

zstyle ':zle:cd-widget:colors' disabled false

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/Math.zsh
source $ZDOTDIR/ZLE.zsh

# User dirs
typeset -Hhr \
  lutris=~/.local/share/lutris \
  steam=~/.local/share/Steam \
  golang=~/.local/lib64/golang \
  retroarch=~/.var/app/org.libretro.RetroArch/config/retroarch \
  zealdocs=~/.var/app/org.zealdocs.Zeal/data/Zeal/Zeal/docsets \
  flatpak=/var/lib/flatpak

: ~lutris ~steam ~golang ~retroarch ~zealdocs ~flatpak
