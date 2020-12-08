aug userft
  " Missing Globs:
  " *.prettierrc - JSON or YAML
  " *.graphqlrc - JSON or YAML
  " *.eslintrc - JSON or YAML; Deprecated
  "
  " *.asmdef - Didn't check
  " *.ckan - Didn't check
  " *.commitlintrc - Didn't check; Probably JSON
  " *.creatomic - No idea
  " *.cryproj - Didn't check
  " *.har - Didn't check
  " *.httpmockrc - Didn't check; Probably JSON
  " *.huskyrc - Didn't check; Probably JSON
  " *.lintstagedrc - Didn't check; Probably JSON
  " *.manifest - Didn't check, possibly too generic
  " *.map - Glob too generic
  " *.mtaext - Didn't check
  " *.nodehawkrc - No idea
  " *.renovaterc - Didn't check
  " *.rules - Probably too generic
  " *.solidarity - Didn't check
  " *.sprite - Didn't check
  " *.stylelintrc - Didn't check
  " *.tsdrc - Didn't check
  " *.typingsrc - Didn't check
  " *.version - Didn't check; Glob too generic
  " *.vg - Didn't check; Possibly too generic
  " *.vl - Didn't check; Possibly too generic
  " *.vsconfig - Didn't check
  " *.vsext - Didn't check
  " */package.manifest - Didn't check

  " Alsa config
  au BufNewFile,BufRead */etc/alsa/*.conf setf alsaconf
  au BufNewFile,BufRead */share/alsa/alsa.conf.d/* setf alsaconf

  " Brainfuck
  au BufNewFile,BufRead *.bf setf brainfuck

  " Crontab
  au BufNewFile,BufRead */etc/anacrontab setf crontab

  " Desktop files
  au BufNewFile,BufRead */flatpak/app/*/*/*/metadata setf desktop
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
  au BufNewFile,BufRead *.babelrc setf json " Alias for .babelrc.json
  au BufNewFile,BufRead *.avsc setf json " Hopefully this is fune
  au BufNewFile,BufRead *.jscsrc setf json " Schemastore only has this and .json
  au BufNewFile,BufRead *.resjson setf json
  au BufNewFile,BufRead *.bowerrc setf json " Docs make it look like this is fine
  au BufNewFile,BufRead *.csslintrc setf json " Can't find docs
  au BufNewFile,BufRead *.htmlhintrc setf json " Can't find docs
  au BufNewFile,BufRead *.jsinspectrc setf json " Could be wrong
  au BufNewFile,BufRead *.jsonld setf json " This has to be fine
  au BufNewFile,BufRead *.modernizrrc setf json " Could be wrong
  au BufNewFile,BufRead *.npmpackagejsonlintrc setf json " Docs don't really mention this

  " JSON w/ comments
  " This doesn't seem to work
  au BufNewFile,BufRead */coc-settings.json setf jsonc
  au BufNewFile,BufRead */tsconfig.json setf jsonc
  au BufNewFile,BufRead */.vscode/*.json setf jsonc
  au BufNewFile,BufRead */waybar/config setf jsonc
  au BufNewFile,BufRead *.jsbeautifyrc setf jsonc " Example I found had comments

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
  au BufNewFile,BufRead *.bootstraprc setf yaml " As far as I can tell this is YAML

  " Zsh
  au BufNewFile,BufRead */share/zsh/*/functions/* setf zsh
  au BufNewFile,BufRead */share/zsh/*/scripts/* setf zsh
  au BufNewFile,BufRead */share/zsh/site-functions/* setf zsh
  au BufNewFile,BufRead */.config/zsh/functions/* setf zsh

  au BufNewFile,BufRead */share/zsh/history setf zshhist
  au BufNewFile,BufRead *.zsh_history setf zshhist

aug END
