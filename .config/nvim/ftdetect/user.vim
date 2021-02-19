" aug filetypedetect
  " Stuff that needs to preced the plenary engine
  au BufNewFile,BufRead */.vscode/*.json setf jsonc " VSCode settings

  " Plenary-based filetype detection engine
  au BufNewFile,BufRead * lua require('user.ft').detect_ft()

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
  au BufNewFile,BufRead */waybar/config setf jsonc " Waybar config

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

  " Misc starsetf {{{1
  au BufNewFile,BufRead */etc/DIR_COLORS.*           call s:StarSetf('dircolors')
  au BufNewFile,BufRead */share/zsh/*/functions/*    call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/*/scripts/*      call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/site-functions/* call s:StarSetf('zsh')
  au BufNewFile,BufRead */.config/zsh/functions/*    call s:StarSetf('zsh')

  " Cleanup {{{1
  au! BufNewFile,BufRead *.json
  au! BufNewFile,BufRead *.ll
  " 1}}}
" aug END
" vim:fdm=marker
