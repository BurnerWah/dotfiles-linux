aug userft

  " Alsa config
  au BufNewFile,BufRead */etc/alsa/*.conf setf alsaconf
  au BufNewFile,BufRead */share/alsa/alsa.conf.d/* setf alsaconf

  " Brainfuck
  au BufNewFile,BufRead *.bf setf brainfuck

  " Crontab
  au BufNewFile,BufRead */etc/anacrontab setf crontab

  " Desktop files
  au BufNewFile,BufRead /var/lib/flatpak/app/*/*/*/metadata setf desktop
  au BufNewFile,BufRead */flatpak/overrides/* setf desktop
  au BufNewFile,BufRead */mimeapps.list setf desktop

  " DirColors
  au BufNewFile,BufRead */etc/DIR_COLORS.* setf dircolors

  " DosINI
  au BufNewFile,BufRead *.coveragerc setf dosini
  au BufNewFile,BufRead */tmp/*.repo setf dosini " YUM repos in sudoedit

  " GDBInit
  au BufNewFile,BufRead */etc/gdbinit setf gdb
  au BufNewFile,BufRead *.gdb setf gdb
  au BufNewFile,BufRead */.config/gdbinit setf gdb

  " Go
  au BufNewFile,BufRead */go.mod setf gomod

  " JSON
  au BufNewFile,BufRead */etc/proselintrc,*.proselintrc  setf json
  au BufNewFile,BufRead *.luacompleterc setf json
  au BufNewFile,BufRead *.arcconfig,*.arclint setf json
  au BufNewFile,BufRead *.tcelldb setf json
  au BufNewFile,BufRead *.jshintrc setf json

  " JSON w/ comments
  au BufNewFile,BufRead */coc-settings.json setf jsonc
  au BufNewFile,BufRead */tsconfig.json setf jsonc
  au BufNewFile,BufRead */.vscode/*.json setf jsonc
  au BufNewFile,BufRead */waybar/config setf jsonc

  " Lisp
  au BufNewFile,BufRead *.xlisp setf lisp

  " Lua
  au BufNewFile,BufRead *.luacheckrc setf lua

  " ManDB Config
  au BufNewFile,BufRead */etc/man_db.conf setf manconf

  " Registry
  au BufNewFile,BufRead *.reg setf registry

  " Snippets
  au BufNewFile,BufRead *.snippets setf snippets

  " SSH
  au BufNewFile,BufRead */etc/ssh/ssh_config.d/* setf sshconfig

  " uBlock
  au BufNewFile,BufRead *.ublock.txt setf ublock

  " VimL
  au BufNewFile,BufRead */etc/virc setf vim

  " XML
  au BufNewFile,BufRead *.doap,*.tmLanguage,*.natvis setf xml
  au BufNewFile,BufRead */etc/dbus-1/*.conf setf xml
  au BufNewFile,BufRead *.aiml setf xml
  au BufNewFile,BufRead *.lzx setf xml
  au BufNewFile,BufRead *.posxml setf xml

  " YAML
  au BufNewFile,BufRead *.sublime-syntax setf yaml

  " Zsh
  au BufNewFile,BufRead */share/zsh/*/functions/* setf zsh
  au BufNewFile,BufRead */share/zsh/*/scripts/* setf zsh
  au BufNewFile,BufRead */share/zsh/site-functions/* setf zsh
  au BufNewFile,BufRead */.config/zsh/functions/* setf zsh

  au BufNewFile,BufRead */share/zsh/history setf zshhist
  au BufNewFile,BufRead *.zsh_history setf zshhist

aug END
