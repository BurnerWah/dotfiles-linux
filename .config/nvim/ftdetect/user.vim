aug userft
  " Brainfuck
  au BufNewFile,BufRead *.bf setf brainfuck

  " Desktop files
  au BufNewFile,BufRead /var/lib/flatpak/app/*/*/*/metadata setf desktop

  " DosINI
  au BufNewFile,BufRead *.coveragerc setf dosini

  " GDBInit
  au BufNewFile,BufRead /etc/gdbinit setf gdb
  au BufNewFile,BufRead *.gdb setf gdb
  au BufNewFile,BufRead */.config/gdbinit setf gdb

  " Go
  au BufNewFile,BufRead */go.mod setf gomod

  " JSON
  au BufNewFile,BufRead /etc/proselintrc,*.proselintrc  setf json
  au BufNewFile,BufRead *.luacompleterc setf json
  au BufNewFile,BufRead *.arcconfig,*.arclint setf json
  au BufNewFile,BufRead *.tcelldb setf json

  " JSON w/ comments
  au BufNewFile,BufRead */coc-settings.json setf jsonc
  au BufNewFile,BufRead */tsconfig.json setf jsonc
  au BufNewFile,BufRead */.vscode/*.json setf jsonc
  au BufNewFile,BufRead */waybar/config setf jsonc

  " Lua
  au BufNewFile,BufRead *.luacheckrc setf lua

  " Snippets
  au BufNewFile,BufRead *.snippets setf snippets

  " SSH
  au BufNewFile,BufRead /etc/ssh/ssh_config.d/* setf sshconfig

  " VimL
  au BufNewFile,BufRead /etc/virc setf vim

  " XML
  au BufNewFile,BufRead *.doap,*.tmLanguage,*.natvis setf xml

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
