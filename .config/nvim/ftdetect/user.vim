aug userft
  " Notes {{{1
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
  " *.huskyrc - Weird

  " Functions {{{1
  " This is copied from nvim runtime
  func! s:StarSetf(ft)
    if expand("<amatch>") !~ g:ft_ignore_pat
      exe 'setf ' . a:ft
    endif
  endfunc

  " Alsa config {{{1
  au BufNewFile,BufRead */etc/alsa/*.conf               setf alsaconf
  au BufNewFile,BufRead */share/alsa/alsa.conf.d/*.conf setf alsaconf

  " Crontab {{{1
  au BufNewFile,BufRead anacrontab setf crontab

  " Desktop files {{{1
  au BufNewFile,BufRead */dbus-1/*.service       setf desktop " DBus service
  au BufNewFile,BufRead */flatpak/app/*/metadata setf desktop " Flatpak metadata
  au BufNewFile,BufRead */flatpak/overrides/*    setf desktop " Fkatpak override
  au BufNewFile,BufRead index.theme              setf desktop " Icon theme index
  au BufNewFile,BufRead mimeapps.list            setf desktop " XDG Default Applications
  au BufNewFile,BufRead mimeinfo.cache           setf desktop " XDG Mime cache

  " DirColors {{{1
  au BufNewFile,BufRead */etc/DIR_COLORS.* call s:StarSetf('crontab')

  " DosINI {{{1
  au BufNewFile,BufRead *.coveragerc setf dosini
  au BufNewFile,BufRead */tmp/*.repo setf dosini " YUM repos in sudoedit

  " GDBInit {{{1
  au BufNewFile,BufRead gdbinit setf gdb
  au BufNewFile,BufRead *.gdb   setf gdb

  " JSON {{{1
  au BufNewFile,BufRead *.arcconfig,*.arclint     setf json
  au BufNewFile,BufRead *.avsc                    setf json " Avro Schema
  au BufNewFile,BufRead *.bowerrc                 setf json " Bower config
  au BufNewFile,BufRead *.csslintrc               setf json " CSS Lint config
  au BufNewFile,BufRead *.htmlhintrc              setf json " HTML Hint config
  au BufNewFile,BufRead *.jscsrc                  setf json " JSCS config
  au BufNewFile,BufRead *.jsinspectrc             setf json " JSInspect config
  au BufNewFile,BufRead *.jsonld                  setf json " JSON Linked Data
  au BufNewFile,BufRead *.luacompleterc           setf json
  au BufNewFile,BufRead *.modernizrrc             setf json " Webpack modernizr-loader config
  au BufNewFile,BufRead *.npmpackagejsonlintrc    setf json " npm-package-json-lint config
  au BufNewFile,BufRead *.proselintrc,proselintrc setf json
  au BufNewFile,BufRead *.resjson                 setf json " Windows App localization
  au BufNewFile,BufRead *.tcelldb                 setf json

  " JSON w/ comments {{{1
  au BufNewFile,BufRead .babelrc.json,babel.config.json let b:is_jsonc = 1 " Babel config

  au BufNewFile,BufRead */.vscode/*.json  let b:is_jsonc = 1 " VSCode settings
  au BufNewFile,BufRead .eslintrc.json    let b:is_jsonc = 1 " ESLint config
  au BufNewFile,BufRead coc-settings.json let b:is_jsonc = 1 " Coc.nvim settings
  au BufNewFile,BufRead coffeelint.json   let b:is_jsonc = 1 " Coffeelint config
  au BufNewFile,BufRead jsconfig.json     let b:is_jsonc = 1 " JS project config
  au BufNewFile,BufRead tsconfig.json     let b:is_jsonc = 1 " TS project config

  au BufNewFile,BufRead *.babelrc       let [&filetype, b:is_jsonc] = ['json', 1] " Alias for .babelrc.json
  au BufNewFile,BufRead *.jsbeautifyrc  let [&filetype, b:is_jsonc] = ['json', 1] " js-beautify config, example had comments
  au BufNewFile,BufRead *.jshintrc      let [&filetype, b:is_jsonc] = ['json', 1] " JSHint config
  au BufNewFile,BufRead *.jslintrc      let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead *.jsonc,*.cjson let [&filetype, b:is_jsonc] = ['json', 1]
  au BufNewFile,BufRead */waybar/config let [&filetype, b:is_jsonc] = ['json', 1] " Waybar config

  " Lisp {{{1
  au BufNewFile,BufRead *.xlisp setf lisp

  " Lua {{{1
  au BufNewFile,BufRead *.luacheckrc setf lua " Luacheck config

  " ManDB Config {{{1
  au BufNewFile,BufRead man_db.conf setf manconf
  au BufNewFile,BufRead .manpath    setf manconf " User manpath

  " Registry {{{1
  " au BufNewFile,BufRead *.reg setf registry " FIXME this is dumb. Don't do this.

  " Snippets {{{1
  au BufNewFile,BufRead *.snippets setf snippets

  " uBlock {{{1
  au BufNewFile,BufRead *.ublock.txt setf ublock

  " VimL {{{1
  au BufNewFile,BufRead virc setf vim

  " XML {{{1
  au BufNewFile,BufRead *.aiml          setf xml " Artificial Intelligence Markup Language
  au BufNewFile,BufRead *.doap          setf xml " Description of a project
  au BufNewFile,BufRead *.lzx           setf xml " OpenLaszlo
  au BufNewFile,BufRead *.natvis        setf xml
  au BufNewFile,BufRead *.posxml        setf xml " Posxml
  au BufNewFile,BufRead *.tmLanguage    setf xml " Textmate language
  au BufNewFile,BufRead */dbus-1/*.conf setf xml " DBus config

  " YAML {{{1
  au BufNewFile,BufRead *.bootstraprc    setf yaml " Webpack bootstrap-loader config
  au BufNewFile,BufRead *.sublime-syntax setf yaml " Sublime text syntax definiton

  " Zsh {{{1
  au BufNewFile,BufRead */share/zsh/*/functions/*    call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/*/scripts/*      call s:StarSetf('zsh')
  au BufNewFile,BufRead */share/zsh/site-functions/* call s:StarSetf('zsh')
  au BufNewFile,BufRead */.config/zsh/functions/*    call s:StarSetf('zsh')

  au BufNewFile,BufRead */share/zsh/history setf zshhist
  au BufNewFile,BufRead *.zsh_history       setf zshhist

  " 1}}}
aug END
" vim:fdm=marker
