# Aliases for zsh
if (( $+aliases[fsh-alias] )) unalias fsh-alias
if (( $+aliases[which] )) unalias which

alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1 | tail -n 1)) && eval $TF_CMD ; test -n "$TF_CMD" && print -s $TF_CMD'

if (( ! $+commands[autopep8] && $+commands[autopep8-3] )) alias autopep8=autopep8-3
if (( $+commands[pxz] )) alias xz=pxz unxz="pxz -d"
if (( $+commands[pigz] )) alias gzip=pigz gunzip="pigz -d" zcat="pigz -dc"
if (( $+commands[pbzip2] )) alias bzip2=pbzip2 bunzip2="pbzip2 -d" bzcat="pbzip -dc"

alias blkid="grc ${aliases[blkid]:-blkid}"
alias bmon="${aliases[bmon]:-bmon} -U"
alias df="grc ${aliases[df]:-df} -hH"
alias diff="${aliases[diff]:-diff} --color=auto"
alias dig="grc ${aliases[dig]:-dig}"
alias dmesg="${aliases[dmesg]:-dmesg} -H"
alias du="grc ${aliases[du]:-du} -h"
alias exa="${aliases[exa]:-exa} -F" ll='exa -lh' la='ll -a'
alias fdisk="grc ${aliases[fdisk]:-fdisk}"
alias findmnt="grc ${aliases[findmnt]:-findmnt}"
alias free="grc ${aliases[free]:-free} -h --si"
alias getsebool="grc ${aliases[getsebool]:-getsebool}"
alias grc='grc -es --colour=auto'
alias grep='ugrep -G' egrep='ugrep -E' fgrep='ugrep -F'
alias id="grc ${aliases[id]:-id}"
alias ifconfig="grc ${aliases[ifconfig]:-ifconfig}"
alias ip="grc ${aliases[ip]:-ip}"
alias iptables="grc ${aliases[iptables]:-iptables}"
alias ls="${aliases[ls]:-ls} --color=auto --quoting-style=literal -F" l=ls
alias lsblk="grc ${aliases[lsblk]:-lsblk}"
alias lsmod="grc ${aliases[lsmod]:-lsmod}"
alias lsof="grc ${aliases[lsof]:-lsof}"
alias lspci="grc ${aliases[lspci]:-lspci}"
alias mtr="grc ${aliases[mtr]:-mtr}"
alias ncdu="${aliases[ncdu]:-ncdu} --si --color dark"
alias netstat="grc ${aliases[netstat]:-netstat}" ports='netstat -ntup'
alias ping="grc ${aliases[ping]:-ping}" ping4='ping -4'
alias semanage="grc ${aliases[semanage]:-semanage}"
alias traceroute="grc ${aliases[traceroute]:-traceroute}"
alias traceroute6="grc ${aliases[traceroute6]:-traceroute6}"
alias wineconsole="${aliases[wineconsole]:-wineconsole} --backend=curses"
alias zgrep='ugrep -zG' zegrep='ugrep -zE' zfgrep='ugrep -zF'

alias cmd=command fns=functions fn=function unfn=unfunction fun=function unfun=unfunction func=function unfunc=unfunction ng=noglob xopen=xdg-open

if [[ $TERM = 'xterm-kitty' ]] alias icat='kitty +kitten icat'

alias ex='nvim -e' vi=nvim vim=nvim view='nvim -R' vimdiff='nvim -d'

# vim:ft=zsh fdm=marker
