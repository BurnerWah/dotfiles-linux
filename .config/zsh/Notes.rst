###########
 Zsh notes
###########

Zsh's documentation is a bit of a nightmare to reference, so this is where I'm keeping my own personal documentation.


Shell startup
#############

This is meant as a real-world example of what Zsh does when it starts up.

1. Source `/etc/zshenv`
2. Source `$ZDOTDIR/.zshenv`
3. Source `/etc/zprofile` (login only)
4. Source `/etc/profile` (login only, from /etc/zprofile)
5. Source `/etc/profile.d/*.sh` (login only, from /etc/profile)
6. Source `/etc/profile.d/sh.local` (login only, from /etc/profile)
7. Source `$ZDOTDIR/.zprofile` (login only)
8. Source `/etc/zshrc` (interactive only)
9. Source `/etc/profile.d/*.sh` (interactive only, from /etc/zshrc)
10. Source `$ZDOTDIR/.zshrc` (interactive only)
11. Source `/etc/zlogin` (login only)
12. Source `$ZDOTDIR/.zlogin` (login only)


Modlues
#######

Zsh modules contain functionality for the shell.
They are managed with the `zmodload` builtin.

I prefer having most modules either loaded at startup, or autoloaded as needed.

Note that the `zsh/main` module is a pseudo-module that can't be manipulated, and that the `zsh/rlimits` module is undocumented.


Completion
##########

Zsh has a powerful completion system, which I use a lot.
It can be configured with the `zstyle` builtin, as well as functions like `compdef`.
