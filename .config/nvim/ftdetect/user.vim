aug userft
  " Plenary-based filetype detection engine
  au BufRead,BufNewFile * lua require('user.ft').detect_ft()

  " Functions {{{1
  " This is copied from nvim runtime
  func! s:StarSetf(ft)
    if expand("<amatch>") !~ g:ft_ignore_pat
      exe 'setf ' . a:ft
    endif
  endfunc

  " Misc {{{1
  au BufNewFile,BufRead */.cargo/config,*/.cargo/credentials setf toml
  au BufNewFile,BufRead */tmp/*.repo setf dosini " YUM repos in sudoedit
  au BufNewFile,BufRead */dbus-1/*.conf setf xml " DBus config
  au BufNewFile,BufRead */share/zsh/history setf zshhist

  " au BufNewFile,BufRead *.reg setf registry " FIXME this is dumb. Don't do this.

  " Alsa config {{{1
  au BufNewFile,BufRead */etc/alsa/*.conf               setf alsaconf
  au BufNewFile,BufRead */share/alsa/alsa.conf.d/*.conf setf alsaconf

  " Desktop files {{{1
  au BufNewFile,BufRead */dbus-1/*.service       setf desktop " DBus service
  au BufNewFile,BufRead */flatpak/app/*/metadata setf desktop " Flatpak metadata
  au BufNewFile,BufRead */flatpak/overrides/*    setf desktop " Fkatpak override

  " Git ignore {{{1
  au BufNewFile,BufRead */.config/git/ignore setf gitignore
  au BufNewFile,BufRead *.git/info/exclude   setf gitignore

  " JSON w/ comments {{{1
  " au BufNewFile,BufRead .babelrc.json,babel.config.json let b:is_jsonc = 1 " Babel config

  " au BufNewFile,BufRead */.vscode/*.json  let b:is_jsonc = 1 " VSCode settings
  " au BufNewFile,BufRead .eslintrc.json    let b:is_jsonc = 1 " ESLint config
  " au BufNewFile,BufRead coc-settings.json let b:is_jsonc = 1 " Coc.nvim settings
  " au BufNewFile,BufRead coffeelint.json   let b:is_jsonc = 1 " Coffeelint config
  " au BufNewFile,BufRead jsconfig.json     let b:is_jsonc = 1 " JS project config
  " au BufNewFile,BufRead tsconfig.json     let b:is_jsonc = 1 " TS project config

  " au BufNewFile,BufRead *.babelrc       let [&filetype, b:is_jsonc] = ['json', 1] " Alias for .babelrc.json
  " au BufNewFile,BufRead *.jsbeautifyrc  let [&filetype, b:is_jsonc] = ['json', 1] " js-beautify config, example had comments
  " au BufNewFile,BufRead *.jshintrc      let [&filetype, b:is_jsonc] = ['json', 1] " JSHint config
  " au BufNewFile,BufRead *.jslintrc      let [&filetype, b:is_jsonc] = ['json', 1]
  " au BufNewFile,BufRead *.jsonc,*.cjson let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead */waybar/config let [&filetype, b:is_jsonc] = ['json', 1] " Waybar config

  " Misc starsetf {{{1
  au BufNewFile,BufRead */etc/DIR_COLORS.*           call s:StarSetf('dircolors')
  au BufNewFile,BufRead */share/zsh/*/functions/*    call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/*/scripts/*      call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/site-functions/* call s:StarSetf('zsh')
  au BufNewFile,BufRead */.config/zsh/functions/*    call s:StarSetf('zsh')

  " 1}}}
aug END
" vim:fdm=marker
