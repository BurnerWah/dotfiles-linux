aug userft
  " Missing Globs:
  " *.prettierrc - JSON or YAML
  " *.graphqlrc - JSON or YAML
  " *.eslintrc - JSON or YAML; Deprecated
  "
  " *.asmdef - Didn't check
  " *.ckan - Didn't check
  " *.creatomic - No idea
  " *.cryproj - Didn't check
  " *.har - Didn't check
  " *.httpmockrc - Didn't check; Probably JSON
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
  "
  " Skipped Globs:
  " *.commitlintrc - No documentation, likely unsupported.

  " This is copied from nvim runtime
  func! s:StarSetf(ft)
    if expand("<amatch>") !~ g:ft_ignore_pat
      exe 'setf ' . a:ft
    endif
  endfunc

  " Alsa config
  au BufNewFile,BufRead */etc/alsa/*.conf setf alsaconf
  au BufNewFile,BufRead */share/alsa/alsa.conf.d/*.conf setf alsaconf

  " Crontab
  au BufNewFile,BufRead anacrontab setf crontab

  " Desktop files
  au BufNewFile,BufRead */flatpak/app/*/*/*/metadata setf desktop
  au BufNewFile,BufRead */flatpak/overrides/* setf desktop
  au BufNewFile,BufRead mimeapps.list setf desktop

  " DirColors
  au BufNewFile,BufRead */etc/DIR_COLORS.* call s:StarSetf('crontab')

  " DosINI
  au BufNewFile,BufRead *.coveragerc setf dosini
  au BufNewFile,BufRead */tmp/*.repo setf dosini " YUM repos in sudoedit

  " GDBInit
  au BufNewFile,BufRead gdbinit setf gdb
  au BufNewFile,BufRead *.gdb setf gdb

  " Go
  au BufNewFile,BufRead go.mod setf gomod

  " JSON
  au BufNewFile,BufRead *.arcconfig,*.arclint setf json
  au BufNewFile,BufRead *.avsc setf json " Hopefully this is fune
  au BufNewFile,BufRead *.bowerrc setf json " Docs make it look like this is fine
  au BufNewFile,BufRead *.csslintrc setf json " Can't find docs
  au BufNewFile,BufRead *.htmlhintrc setf json " Can't find docs
  au BufNewFile,BufRead *.jscsrc setf json " Schemastore only has this and .json
  au BufNewFile,BufRead *.jsinspectrc setf json " Could be wrong
  au BufNewFile,BufRead *.jsonld setf json " This has to be fine
  au BufNewFile,BufRead *.luacompleterc setf json
  au BufNewFile,BufRead *.modernizrrc setf json " Could be wrong
  au BufNewFile,BufRead *.npmpackagejsonlintrc setf json " Docs don't really mention this
  au BufNewFile,BufRead *.proselintrc,proselintrc setf json
  au BufNewFile,BufRead *.resjson setf json
  au BufNewFile,BufRead *.tcelldb setf json


  " JSON w/ comments
  au BufNewFile,BufRead */.vscode/*.json  let b:is_jsonc = 1
  au BufNewFile,BufRead .eslintrc.json    let b:is_jsonc = 1
  au BufNewFile,BufRead coc-settings.json let b:is_jsonc = 1
  au BufNewFile,BufRead coffeelint.json   let b:is_jsonc = 1
  au BufNewFile,BufRead jsconfig.json     let b:is_jsonc = 1
  au BufNewFile,BufRead tsconfig.json     let b:is_jsonc = 1

  au BufNewFile,BufRead *.babelrc       let [&filetype, b:is_jsonc] = ['json', 1] " Alias for .babelrc.json
  au BufNewFile,BufRead *.jsbeautifyrc  let [&filetype, b:is_jsonc] = ['json', 1] " Example I found had comments
  au BufNewFile,BufRead *.jshintrc      let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead *.jslintrc      let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead *.jsonc,*.cjson let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead */waybar/config let [&filetype, b:is_jsonc] = ['json', 1]

  " Lisp
  au BufNewFile,BufRead *.xlisp setf lisp

  " Lua
  au BufNewFile,BufRead *.luacheckrc setf lua

  " ManDB Config
  au BufNewFile,BufRead man_db.conf setf manconf

  " Registry
  " au BufNewFile,BufRead *.reg setf registry " FIXME this is dumb. Don't do this.

  " Shell
  au BufNewFile,BufRead *.huskyrc call dist#ft#SetFileTypeSH('bash') " Husky is weird.

  " Snippets
  au BufNewFile,BufRead *.snippets setf snippets

  " uBlock
  au BufNewFile,BufRead *.ublock.txt setf ublock

  " VimL
  au BufNewFile,BufRead virc setf vim

  " XML
  au BufNewFile,BufRead *.aiml setf xml
  au BufNewFile,BufRead *.doap setf xml
  au BufNewFile,BufRead *.lzx setf xml
  au BufNewFile,BufRead *.natvis setf xml
  au BufNewFile,BufRead *.posxml setf xml
  au BufNewFile,BufRead *.tmLanguage setf xml
  au BufNewFile,BufRead */etc/dbus-1/*.conf setf xml

  " YAML
  au BufNewFile,BufRead *.bootstraprc setf yaml " As far as I can tell this is YAML
  au BufNewFile,BufRead *.sublime-syntax setf yaml

  " Zsh
  au BufNewFile,BufRead */share/zsh/*/functions/*    call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/*/scripts/*      call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/site-functions/* call s:StarSetf('zsh')
  au BufNewFile,BufRead */.config/zsh/functions/*    call s:StarSetf('zsh')

  au BufNewFile,BufRead */share/zsh/history setf zshhist
  au BufNewFile,BufRead *.zsh_history setf zshhist

aug END
