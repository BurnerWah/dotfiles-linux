# Aliases for zsh
if (( $+aliases[fsh-alias] )) unalias fsh-alias
if (( $+aliases[which] )) unalias which

alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1 | tail -n 1)) && eval $TF_CMD ; test -n "$TF_CMD" && print -s $TF_CMD'

if (( ! $+commands[autopep8] && $+commands[autopep8-3] )) alias autopep8=autopep8-3
if (( $+commands[colormake] )) alias make=colormake
if (( $+commands[pxz] )) alias xz=pxz unxz="pxz -d"
if (( $+commands[pinfo] )) alias info=pinfo

alias blkid="grc ${aliases[blkid]:-blkid}"
alias df="grc ${aliases[df]:-df} -hH"
alias diff="${aliases[diff]:-diff} --color=auto"
alias dig="grc ${aliases[dig]:-dig}"
alias du="grc ${alias[du]:-du} -h"
alias exa="${aliases[exa]:-exa} -F" ll='exa -lh' la='ll -a'
alias fd="noglob ${aliases[fd]:-fd}"
alias fdisk="grc ${aliases[fdisk]:-fdisk}"
alias findmnt="grc ${aliases[findmnt]:-findmnt}"
alias free="grc ${aliases[free]:-free}"
alias getsebool="grc ${aliases[getsebool]:-getsebool}"
alias grc='grc -es --colour=auto'
alias id="grc ${aliases[id]:-id}"
alias ifconfig="grc ${aliases[ifconfig]:-ifconfig}"
alias ip="grc ${aliases[ip]:-ip}"
alias iptables="grc ${aliases[iptables]:-iptables}"
alias jq="noglob ${aliases[jq]:-jq}"
alias ls="${aliases[ls]:-ls} --color=auto --quoting-style=literal -F" l=ls
alias lsblk="grc ${aliases[lsblk]:-lsblk}"
alias lsmod="grc ${aliases[lsmod]:-lsmod}"
alias lsof="grc ${aliases[lsof]:-lsof}"
alias lspci="grc ${aliases[lspci]:-lspci}]"
alias mtr="grc ${aliases[mtr]:-mtr}"
alias netstat="grc ${aliases[netstat]:-netstat}" ports='netstat -ntup'
alias ping="grc ${aliases[ping]:-ping}" ping4='ping -4'
alias please=sudo
alias rg="noglob ${aliases[rg]:-rg}"
alias semanage="grc ${aliases[semanage]:-semanage}"
alias traceroute="grc ${aliases[traceroute]:-traceroute}"
alias traceroute6="grc ${aliases[traceroute6]:-traceroute6}"
alias wineconsole="${aliases[wineconsole]:-wineconsole} --backend=curses"
alias youtube-dl="noglob ${aliases[youtube-dl]:-youtube-dl}"
alias zrestart='exec zsh'
alias zt='z -t' zc='z -c'

alias cmd=command
alias fns=functions
alias fn=function unfn=unfunction
alias fun=function unfun=unfunction
alias func=function unfunc=unfunction
alias ng=noglob
alias wg=wget
alias xopen=xdg-open

alias -s bashrc="bash --rcfile "
alias -s json="jq ''"

if [[ $TERM = 'xterm-kitty' ]] alias icat='kitty +kitten icat'

functions+=(
  ex      'nvim -e "$@"'
  vi      'nvim "$@"'
  vim     'nvim "$@"'
  view    'nvim -R "$@"'
  vimdiff 'nvim -d "$@"'
)
alias ex='nvim -e' vi=nvim vim=nvim view='nvim -R' vimdiff='nvim -d'

# vim:ft=zsh:fdm=marker
