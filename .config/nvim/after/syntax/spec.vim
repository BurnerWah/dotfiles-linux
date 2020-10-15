" The built in spec.vim has a lot of issues, so it's not a bad idea to just
" remake the whole thing from scratch. However, that would take a really long
" time and I mostly just want a quick-ish fix that I can apply over the
" standard spec.vim for now.
"
" TODO add spelling to changelog

" Fix spelling issues
syn match specComment '^\s*#.*$' contains=@Spell

" Add conditional (I think) macro identifiers
syn match specMacroIdentifier contained '%{!\??\w*}' contains=specMacroNameLocal,specMacroNameOther,specPercent,specSpecialChar,specSpecialCharCondit
syn match specMacroIdentifier contained '%{with \w*}' contains=specMacroNameLocal,specMacroNameOther,specPercent,specSpecialChar,specSpecialCharCondit,specMacroIdentifierCondit

" Add special char edge case
syn match specSpecialChar contained '[<>]=\|=[<>]'

syn match specSpecialCharCondit contained '[!?]'
syn keyword specMacroIdentifierCondit contained with

" macros
" let s:macros = {
"       \   'core': {
"       \     'main': [
"       \       'define', 'patch\d*', 'configure', 'GNUconfigure', 'setup',
"       \       'autosetup', 'autopatch', 'find_lang', 'make_build',
"       \       'make_\?install',
"       \     ],
"       \   },
"       \   'misc': {'main': ['fdupes']},
"       \   'cmake': {
"       \     'main': [
"       \       'cmake3\?', 'cmake3\?_build'
"       \     ],
"       \   },
"       \ }

" Scripts section
exe 'syn region specScriptArea matchgroup=specSection start=/^%\('.join([
      \   'prep', 'build', 'install', 'clean', 'pre', 'postun', 'preun',
      \   'post', 'posttrans', 'check', 'generate_buildrequires',
      \ ], '\|').'\)\>/ skip=/^%{\|^%\('.join([
      \   'define', 'patch\d*', 'configure', 'GNUconfigure', 'setup', 'autosetup', 'autopatch',
      \   'find_lang', 'make_build', 'make_\?install',
      \
      \   'fdupes',
      \
      \   'cmake3\?', 'cmake3\?_build', 'cmake3\?_install', 'ctest3\?',
      \
      \   'gopkg', 'godevelpkg', 'goaltpkg',
      \
      \   'py[23]\?_build', 'py[23]\?_install', 'py[23]\?_install_egg', 'py[23]\?_install_wheel',
      \   'pytest',
      \
      \   'ninja_build', 'ninja_install', 'ninja_test',
      \
      \   'cargo_prep', 'cargo_generate_buildrequires', 'cargo_build', 'cargo_test', 'cargo_install',
      \   'crates_source',
      \ ], '\|').'\)\>/ end=/^%/me=e-1 contains='.join([
      \   'specSpecialVariables', 'specVariables', '@specCommands',
      \   'specVariables', 'shDo', 'shFor', 'shCaseEsac', 'specNoNumberHilite',
      \   'specCommandOpts', 'shComment', 'shIf', 'specSpecialChar',
      \   'specMacroIdentifier', 'specSectionMacroArea',
      \   'specSectionMacroBracketArea', 'shOperator', 'shQuote1', 'shQuote2',
      \ ], ',')

" Add support for more macros
exe 'syn region specSectionMacroArea oneline matchgroup=specSectionMacro start=/^%\('.join([
      \   'define', 'global', 'patch\d*', 'setup', 'autosetup', 'autopatch', 'configure',
      \   'GNUconfigure', 'find_lang', 'make_build', 'make_\?install', 'include',
      \   'bcond_with', 'bcond_without',
      \
      \   'fdupes',
      \
      \   'cmake3\?', 'cmake3\?_build', 'cmake3\?_install', 'ctest3\?',
      \
      \   'gorpmname', 'gometa',
      \   'gopkg', 'godevelpkg', 'goaltpkg',
      \
      \   'py[23]\?_build', 'py[23]\?_install', 'py[23]\?_install_egg', 'py[23]\?_install_wheel',
      \   'pytest',
      \
      \   'ninja_build', 'ninja_install', 'ninja_test',
      \
      \   'cargo_prep', 'cargo_generate_buildrequires', 'cargo_build', 'cargo_test', 'cargo_install',
      \   'crates_source',
      \ ], '\|').'\)\>/ end=/$/ contains='.join([
      \   'specCommandOpts', 'specMacroIdentifier',
      \ ], ',')

" Add more files directives
exe 'syn region specFilesArea matchgroup=specSection start=/^%[Ff][Ii][Ll][Ee][Ss]\>/ skip=/%\('.join([
      \   'attrib', 'defattr', 'attr', 'dir', 'config', 'docdir', 'doc', 'lang', 'license',
      \   'verify', 'ghost', 'exclude',
      \
      \   'gopkgfiles', 'godevelfiles', 'goaltfiles',
      \
      \   'pycached',
      \ ], '\|').'\)\>/ end=/^%[a-zA-Z]/me=e-2 contains='.join([
      \   'specFilesOpts', 'specFilesDirective', '@specListedFiles',
      \   'specComment', 'specCommandSpecial', 'specMacroIdentifier',
      \ ], ',')
exe 'syn match  specFilesDirective contained /%\('.join([
      \   'attrib', 'defattr', 'attr', 'dir', 'config', 'docdir', 'doc',
      \   'lang', 'license', 'verify', 'ghost', 'exclude',
      \   'gopkgfiles',
      \ ], '\|').'\)\>/'


" Add more command keywords
syn keyword specCommand contained
      \ pushd popd
      \ doxygen
      \ cargo
syn match specCommand contained 'desktop-file-install'

" add more macro names
syn keyword specMacroNameOther contained
      \ golang_arches gccgo_arches go_arches gopath go_compiler
      \
      \ python_sitelib python2_sitelib python3_sitelib
      \
      \ cargo_registry rust_arches crates_source build_rustflags

" add more _macro names
syn keyword specMacroNameLocal contained
      \ _isa
      \
      \ _cmake_lib_suffix64 _cmake_shared_libs _cmake_skip_rpath _cmake_version


" fix some highlighting fuckery that occurs in spec.vim
hi clear specGlobalMacro
hi def link specGlobalMacro Identifier
hi def link specSpecialCharCondit Conditional
hi def link specMacroIdentifierCondit Conditional
hi def link specMacroIdentifierAny Identifier
