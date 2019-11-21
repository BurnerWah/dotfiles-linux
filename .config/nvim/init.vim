" File: init.vim
" Author: Jaden Pleasants
" Description: neovim configuration
" Last Modified: September 16, 2019

" Notes {{{1
" This configuration is specifically targeting neovim. It doesn't have a check
" to see if that's what you're running at the start, but it will probably
" throw a lot of errors if for some reason you decide to load this in regular
" Vim.
"
" Also, since Vim allows you to use shortened versions of keywords, I'm
" sticking to the shortest version that makes sense.
"
" Core settings {{{1
scriptenc 'utf-8'
filetype plugin indent on " Load plugins according to detected filetype.
syn enable             " Enable syntax highlighting.

set expandtab          " Use spaces instead of tabs.
set tabstop     =8
set softtabstop =2     " Tab key indents by 2 spaces.
set shiftwidth  =2     " >> indents by 2 spaces.
set shiftround         " >> indents to next multiple of 'shiftwidth'.
set smartindent
set hidden             " Switch between buffers without having to save first.
set lazyredraw         " Only redraw when necessary.
set splitbelow         " Open new windows below the current window.
set splitright         " Open new windows right of the current window.
set cursorline         " Find the current line quickly.
set report      =0     " Always report changed lines.
set synmaxcol   =250   " Only highlight the first 250 columns.
set mouse       =a     " Mouse support
set termguicolors      " Truecolor mode
set spell              " Enable spell correction
set spelllang   =en_us " Set language for spelling
set pumblend    =10    " Slightly transparent menus
set sessionoptions  =blank,curdir,folds,help,localoptions,tabpages,winpos,winsize
set list               " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif
if has('conceal')
  set conceallevel  =2
  set concealcursor =nv
endif

let g:loaded_ruby_provider = 0
" let g:loaded_node_provider = 0
let fennel_nvim_auto_init = v:false

" Maybe someday I'll be able to remove this block
if &shell =~# 'fish$'
  set shell=zsh
endif

" Early augroup
aug init.colors
  au!
  au ColorScheme quantum runtime! after/colors/quantum.vim
aug END

" Dein: plugin manager {{{1
" Notes {{{2
" dein is a fairly capable plugin manager, but it has it's limitations. It
" tries to merge plugins together, which is an interesting idea that I think
" could've been executed better.
"
" * Plugins are merged using rsync, and dein does basically nothing to track
"   which files came from what plugins. As a result, remote plugins can
"   sometimes break when their configuration is changed (for instance, a plugin
"   that used to be merged isn't able to be merged anymore).
" * rsync also wastes a lot of space, and can slow the update process
"   unnecessarily when there aren't any new files.
" * Lastly, the rsync method doesn't seem to allow for any way to really
"   resolve conflicts between plugins. If two plugins include
"   rtp:/syntax/vim.json, there isn't a meaningful way to specify which one
"   should override the other.
"
" I think that while it would be more complex, there would be ways to avoid
" this issue. For instance:
" * Using symlinks to files to merge plugins would almost eliminate the
"   excess space used by dein, and would speed up updates when there weren't
"   any new files.
" * Using a traditional FUSE mount (similar to overlayfs or MOVFS) could hide
"   the fact that plugins were merged at all, let dein resolve conflicts, and
"   maintain an overwrite folder for files created at runtime.
"
" It's also worth mentioning that while there is a third-party user interface
" for dein available, it seems to be pretty buggy. I don't use it personally.
"
" Settings {{{2
let g:dein#install_log_filename = stdpath('data').'/logs/dein.log'
let g:dein#enable_notification = v:true

" Required {{{2
" Technically dein requires nocompatible to be set, but that's always true
" for nvim.

" Required
set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

" Required
if dein#load_state('~/.local/share/dein')
  call dein#begin('~/.local/share/dein')

  " Let dein manage dein
  " Required
  call dein#add('~/.local/share/dein/repos/github.com/Shougo/dein.vim')

  " Helpful variables {{{2
  let s:gitlab = 'https://gitlab.com/'
  let s:gh_raw = 'https://raw.githubusercontent.com'

  " Core plugins {{{2
  call dein#add('neoclide/coc.nvim', {'merge': v:false, 'rev': 'release'})

  call dein#add('Shougo/denite.nvim', {'if': has('python3'), 'merged': v:true})

  call dein#add('neoclide/coc-denite', {'depends': ['denite.nvim', 'coc.nvim']})

  " Snippets & Templates {{{2
  " call dein#add('neoclide/coc-snippets', {'build': 'yarnpkg install --frozen-lockfile'})
  " call dein#add('honza/vim-snippets')
  " vim-snippets is selectively linked in via stow

  " Language agnostic stuff {{{2
  " Polyglot used to be in here but it tends to break stuff so I don't use it
  " anymore.

  call dein#add('dense-analysis/ale', {'type__depth': 1})
  call dein#add('iyuuya/denite-ale', {'depends': ['denite.nvim', 'ale']})
  " Asynchronous linting engine

  " Language-specific stuff {{{2
  " AWK: {{{3
  " Syntax: $VIMRUNTIME
  " Ftplugin: $VIMRUNTIME
  " Format: $VIMRUNTIME
  " Linter: ALE
  " Snippets: vim-snippets

  call dein#add(s:gitlab.'HiPhish/awk-ward.nvim')

  " CQL: Cassandra CQL {{{3
  call dein#add('elubow/cql-vim')

  " Crystal: {{{3
  let g:loaded_syntastic_crystal_filetype = 0
  call dein#add('rhysd/vim-crystal')

  " CSV: comma-separated values {{{3
  " Ftdetect: csv.vim
  " Ftplugin: csv.vim
  " Syntax: csv.vim

  " call dein#add('chrisbra/csv.vim', {'lazy': v:true, 'on_ft': ['csv']})
  " Has a plugin file but it probably shouldn't.
  " replacing with local fork temporarily

  " Cue: cue sheets {{{3
  call dein#add('mgrabovsky/vim-cuesheet')

  " CXX: {{{3
  " Syntax: chromatica.nvim, $VIMRUNTIME, vim-enhanced-cpp-highlight
  " Format: ALE, language server, $VIMRUNTIME
  " Ftplugin: $VIMRUNTIME
  " Linter: ALE, language server
  " Completion: language server, neoinclude
  " Snippets: vim-snippets

  call dein#add('arakashic/chromatica.nvim')
  " Provides enhanced highlighting. It requires the base CXX syntax definition.

  call dein#add('octol/vim-cpp-enhanced-highlight')
  " Enhancements to base c++ highlighting. It inherently loads lazily.

  " call dein#add('m-pilia/vim-ccls')
  " Enhanced support for ccls.
  " Has a small plugin file
  " redundant with coc.nvim

  call dein#add('Shougo/neoinclude.vim')
  call dein#add('jsfaint/coc-neoinclude', {'depends': ['coc.nvim', 'neoinclude.vim']})

  " Dart: {{{3
  call dein#add('dart-lang/dart-vim-plugin', {'lazy': v:true, 'on_ft': ['dart']})
  " Official dart syntax
  " Load lazily to prevent plugin from sourcing when it doesn't need to
  " Probably can be manually converted to an ftplugin.

  " Docker: dockerfile, docker-compose {{{3
  " Syntax: Dockerfile.vim
  " Format: Dockerfile.vim
  " Ftplugin: Dockerfile.vim
  " Ftdetect: Dockerfile.vim
  " Linter: ALE, coc-docker
  " Completion: coc-docker
  " Snippets: Dockerfile.vim

  call dein#add('ekalinin/Dockerfile.vim')

  " Fennel: {{{3
  call dein#add('bakpakin/fennel.vim')
  call dein#add('jaawerth/fennel-nvim')

  " Fish: {{{3
  call dein#add('dag/vim-fish')

  " Gluon: {{{3
  " Syntax: vim-gluon
  " Ftdetect: vim-gluon
  " Format: vim-gluon
  " Completion: language server (not working)

  call dein#add('gluon-lang/vim-gluon')
  " Official gluon syntax

  " Go: {{{3
  " Syntax: vim-go
  " Ftdetect: vim-go
  " Ftplugin: vim-go
  " Compiler: vim-go
  " Format: ALE, coc-go, vim-go
  " Linter: ALE, coc-go, vim-go?
  " Completion: coc-go, vim-go?
  " Snippets: vim-go, vim-snippets

  call dein#add('fatih/vim-go')

  " I3: {{{3
  call dein#add('mboughaba/i3config.vim')

  " Irdis: {{{3
  call dein#add('idris-hackers/idris-vim')

  " JavaScript: {{{3
  call dein#add('othree/yajs.vim')

  " JSON: {{{3
  " Syntax: vim-json
  " Format: coc-json. ALE, vim-json
  " Ftplugin: vim-json
  " Ftdetect: vim-json
  " Linter: language server, ALE, vim-json
  call dein#add('elzr/vim-json')

  " Julia: {{{3
  call dein#add('JuliaEditorSupport/julia-vim')

  " Kotlin: {{{3
  call dein#add('udalov/kotlin-vim')

  " LLVM: {{{3
  " The llvm highlighting is in a subdirectory of llvm-mirror/llvm, which is a
  " 500mb repository. You're better off directly adding stuff.
  " See: https://github.com/llvm-mirror/llvm/tree/master/utils/vim
  let s:llvm_raw = s:gh_raw.'/llvm-mirror/llvm/master/utils/vim'
  call dein#add(s:llvm_raw.'/ftdetect/llvm-lit.vim', {'script_type': 'ftdetect'})

  call dein#add(s:llvm_raw.'/ftdetect/tablegen.vim', {'script_type': 'ftdetect'})
  call dein#add(s:llvm_raw.'/ftplugin/tablegen.vim', {'script_type': 'ftplugin'})
  call dein#add(s:llvm_raw.'/syntax/tablegen.vim', {'script_type': 'syntax'})

  call dein#add(s:llvm_raw.'/ftdetect/llvm.vim', {'script_type': 'ftdetect'})
  call dein#add(s:llvm_raw.'/ftplugin/llvm.vim', {'script_type': 'ftplugin'})
  call dein#add(s:llvm_raw.'/syntax/llvm.vim', {'script_type': 'syntax'})
  call dein#add(s:llvm_raw.'/indent/llvm.vim', {'script_type': 'indent'})
  unlet s:llvm_raw

  " Markdown: {{{3
  " call dein#add('iamcco/markdown-preview.nvim', {
  "       \ 'lazy': v:true,
  "       \ 'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
  "       \ 'build': 'cd app && npm install --no-bin-links'
  "       \ })

  " Meson: {{{3
  " Official meson syntax is similar to the official llvm syntax
  let s:meson_raw = s:gh_raw.'/mesonbuild/meson/master/data/syntax-highlighting/vim'
  call dein#add(s:meson_raw.'/ftdetect/meson.vim', {'script_type': 'ftdetect'})
  call dein#add(s:meson_raw.'/ftplugin/meson.vim', {'script_type': 'ftplugin'})
  call dein#add(s:meson_raw.'/indent/meson.vim', {'script_type': 'indent'})
  call dein#add(s:meson_raw.'/syntax/meson.vim', {'script_type': 'syntax'})
  unlet s:meson_raw

  " MoonScript: {{{3
  call dein#add('leafo/moonscript-vim')

  " call dein#add('svermeulen/nvim-moonmaker', {'merged': v:false})
  " This plugin deletes files in it's lua dir, so we can't safely merge it.

  " Nim: {{{3
  call dein#add('zah/nim.vim')

  " Python: {{{3
  " Syntax: Semshi, python-syntax
  " Completion: coc-pyls
  " Linter: ale, coc-pyls
  " I used to use python-mode but it turns out that plugin causes more
  " problems than it solves.

  call dein#add('vim-python/python-syntax')

  call dein#add(s:gh_raw.'/Vimjas/vim-python-pep8-indent/master/indent/python.vim', {'script_type': 'indent'})
  " I'm really not sure why this plugin has so much stuff in it's repo. Do you
  " really need a dockerfile, a makefile, a gemfile, a docker compose
  " configuration, and continuous integration for one file?
  " One file? Just one file?

  call dein#add('numirias/semshi', {
        \ 'if': has('nvim') && has('python3'),
        \ 'merged': v:true,
        \ })
  " Semshi provides semantic highlighting for Python code.

  call dein#add('bfredl/nvim-ipy', {'if': has('python3'), 'merged': v:true})
  call dein#add('stsewd/isort.nvim', {'if': has('python3'), 'merged': v:true})

  " QML: {{{3
  call dein#add('peterhoeg/vim-qml')

  " Rust: {{{3
  " Syntax: rust.vim
  " Format: rust.vim, ale, coc-rls?
  " Ftplugin: rust.vim
  " Ftdetect: rust.vim
  " Snippets: vim-snippets, coc-rls
  " Completion: coc-rls
  " Linter: ale, coc-rls

  call dein#add('rust-lang/rust.vim')
  " Official rust syntax

  call dein#add('mhinz/vim-crates')
  " Info on crates

  " Solidity: {{{3
  call dein#add('tomlion/vim-solidity')

  " SVG: {{{3
  call dein#add(s:gh_raw.'/jasonshell/vim-svg-indent/master/indent/svg.vim', {'script_type': 'indent'})

  " Terraform: {{{3
  call dein#add('hashivim/vim-terraform')

  " TeX: {{{3
  call dein#add('lervag/vimtex', {
        \ 'type__depth': 1,
        \ })

  " TOML: {{{3
  call dein#add('cespare/vim-toml')

  " TypeScript: {{{3
  call dein#add('HerringtonDarkholme/yats.vim')

  " Vala: {{{3
  call dein#add('YaBoiBurner/vala.vim')
  " Fork of arrufat/vala.vim

  " Vifm: vifm configuration {{{3
  call dein#add('vifm/vifm.vim')

  " VimL: {{{3
  call dein#add('Shougo/neco-vim')
  call dein#add('neoclide/coc-neco', {'depends': ['coc.nvim', 'neco-vim']})

  " Zsh: {{{3
  " Syntax: mine
  " Completion: coc-zsh

  " For the most part, I'm using a heavily modified version of the Zsh syntax.
  call dein#add('tjdevries/coc-zsh', {
        \ 'if': !empty(exepath('zsh')),
        \ 'depends': ['coc.nvim'],
        \ 'merged': v:true,
        \ })
  " Zsh completions in Zsh scripts.

  " Integration: Work with other things {{{2
  let g:zv_disable_mapping = v:true
  call dein#add('KabbAmine/zeavim.vim')
  " Open documentation in Zeal
  " The default mapping is garbage and overwrites some defaults I'm used to.

  call dein#add('tpope/vim-fugitive')
  " Git wrapper. You know what it does.

  call dein#add('tpope/vim-dadbod')

  call dein#add('neoclide/denite-git', {'depends': ['denite.nvim']})
  call dein#add('Vigemus/iron.nvim')

  " General utilities {{{2
  call dein#add('vimwiki/vimwiki',)
  call dein#add('dunstontc/projectile.nvim', {'depends': ['denite.nvim']})
  call dein#add('Vigemus/nvimux')

  " User interface {{{2
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('Shougo/deol.nvim', {'depends': ['denite.nvim']})
  call dein#add('notomo/denite-autocmd', {'depends': ['denite.nvim']})
  call dein#add('zacharied/denite-nerdfont', {'depends': ['denite.nvim']})
  call dein#add('sakhnik/nvim-gdb')

  call dein#add('rhysd/git-messenger.vim', {
        \ 'lazy': v:true,
        \ 'on_cmd': 'GitMessenger',
        \ 'on_map': '<Plug>(git-messenger',
        \ })
  " View git commit messages in a floating window.

  " Mode-line {{{3
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes', {'depends': ['vim-airline']})
  call dein#add('majutsushi/tagbar')

  " Visual helpers {{{3
  let g:line_number_interval#enable_at_startup = v:true
  call dein#add('IMOKURI/line-number-interval.nvim')

  call dein#add('norcalli/nvim-colorizer.lua')
  " nvim colorizer highlights colors really quickly.

  " call dein#add('meain/vim-package-info', {'build': 'npm install --no-link'})
  " Shows package information in package.json, cargo.toml, etc.
  " Very simple plugin right now, no need to lazy-load.

  " Signcolumn {{{3
  call dein#add('airblade/vim-gitgutter')
  call dein#add('mhinz/vim-signify')

  " Color schemes {{{3
  call dein#add('keitanakamura/neodark.vim')
  call dein#add('tyrannicaltoucan/vim-quantum')
  call dein#add('morhetz/gruvbox')
  " call dein#add('sickill/vim-monokai')
  " call dein#add('joshdick/onedark.vim')
  " call dein#add('challenger-deep-theme/vim', {'name': 'challenger_deep.vim'})
  " call dein#add('jaredgorski/SpaceCamp')
  " call dein#add('nanotech/jellybeans.vim')
  " call dein#add('rakr/vim-one')
  " call dein#add('arcticicestudio/nord-vim')
  " call dein#add('ajmwagar/vim-deus')

  " Text-editing {{{2
  call dein#add('tpope/vim-abolish')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-speeddating')

  call dein#add('farmergreg/vim-lastplace')
  " Open files wherever you were last editing them

  call dein#add('junegunn/vim-easy-align')
  " Align text to certain characters.

  " call dein#add('meain/vim-colorswitch', {'if': has('python3'), 'merged': v:true})
  " Cycle between hex, rgb, and hsl colors

  " Uncategorized {{{2
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('rliang/termedit.nvim')
  call dein#add('fszymanski/fzf-gitignore')
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('Shougo/context_filetype.vim')
  call dein#add('easymotion/vim-easymotion')

  " call dein#add('Yggdroot/LeaderF', {
  "       \ 'merged': v:true,
  "       \ 'build': 'bash install.sh',
  "       \ })

  call dein#add('Shougo/vimproc.vim', {
        \ 'merged': v:true,
        \ 'build': 'make && strip lib/vimproc_linux64.so',
        \ })

  " Required {{{2
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syn enable

" Install missing plugins on startup {{{2
if dein#check_install()
  call dein#install()
endif

" My functions {{{1
"fun! s:in_git_dir(path) abort
"  let dir = fnamemodify(a:path, ':p:h')
"  let root = finddir('.git', dir.';')
"  return !empty(root)
"endfun

" Commands {{{1
com! -nargs=0 Prettier :CocCommand prettier.formatFile
com! -nargs=0 Tsc    :CocCommand tsserver.watchBuild

" Plugin Settings {{{1

let g:snips_author = 'Jaden Pleasants'
let g:snips_email  = 'jadenpleasants@fastmail.com'
let g:git_messenger_always_into_popup = v:true
let g:zv_zeal_executable = 'org.zealdocs.Zeal'
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

lua require("navigation")

exe 'luafile '.stdpath('config').'/config.lua'

" Colorscheme: Currently set to a modded version of quantum {{{2
set background=dark
let g:quantum_black   = v:true
let g:quantum_italics = v:true

colors quantum-mod

" Airline: Bottom bar for Vim. {{{2

" Main settings
let g:airline_powerline_fonts  = v:true " Airline + Powerline
let g:airline_detect_spelllang = v:false " Cleans up stuff a little

" Extensions

let g:airline#extensions#tabline#enabled   = v:true " airline tabs
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" ALE: Asynchronous Linting Engine {{{2
" The two main lint engines I've seen for Vim are ALE and Syntastic. Both are
" extensible engines, but I've noticed that ALE seems to have better
" integration with nvim, and the window syntastic opens up all the time makes
" it a bit of a pain in the ass to edit files that you're actively ignoring
" something in.
"
" Most linters are on by default.
" The following tools are intentionally disabled:
"   ccls: Better handled by coc.nvim
"   rls: Redundant w/ coc-rls
"   pyls: Redundant w/ coc-pyls
"   gopls: Redundant w/ coc-go

let g:ale_linters = {
      \   'c': [
      \     'clang', 'clangd', 'clang-format', 'clangtidy', 'cppcheck',
      \     'cpplint', 'cquery', 'flawfinder', 'gcc', 'uncrustify',
      \   ],
      \   'cpp': [
      \     'clang', 'clangcheck', 'clangd', 'clangtidy', 'clazy',
      \     'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc', 'uncrustify',
      \   ],
      \   'objc':   ['clang', 'clangd', 'uncrustify'],
      \   'sh':     ['shell', 'shellcheck'],
      \ }

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \
      \   'json': ['prettier'],
      \   'xml':  ['xmllint'],
      \
      \   'cmake': ['cmakeformat', 'remove_trailing_lines', 'trim_whitespace'],
      \   'cpp': [
      \     'clang-format', 'clangtidy', 'uncrustify',
      \     'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'go': [
      \     'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'python': [
      \     'add_blank_lines_for_python_control_statements',
      \     'autopep8', 'black', 'isort', 'yapf',
      \   ],
      \   'rust': ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \   'sh':   ['shfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \   'sql':  ['sql-format', 'remove_trailing_lines', 'trim_whitespace'],
      \ }

let g:ale_fix_on_save = v:true

" Chromatica: Remote plugin that enhances clang highlighting {{{2
let g:chromatica#libclang_path     = '/usr/lib64/libclang.so'
let g:chromatica#enable_at_startup = v:true " auto-enable Chromatica when relevant
let g:chromatica#responsive_mode   = v:true " Continuously highlight files
" Without the following args, chromatica won't highlight files correctly.
let g:chromatica#global_args = [
      \ '-isystem/usr/include/c++/9',
      \ '-isystem/usr/include/c++/9/x86_64-redhat-linux',
      \ '-isystem/usr/include/c++/9/backward',
      \ '-isystem/usr/lib64/clang/9.0.0/include',
      \ ]

" Vim-Go: {{{2
let g:go_doc_keywordprg_enabled = v:false
let g:go_def_mapping_enabled = v:false
let g:go_textobj_enabled = v:false

" VimWiki: Note-taking tool {{{2
let g:vimwiki_list = [{
      \   'path': '~/Documents/VimWiki',
      \   'nested_syntaxes': {'c++': 'cpp', 'python': 'python',},
      \ }]

" Syntax Settings {{{1
let g:python_highlight_all = v:true
let g:tex_flavor = 'latex'
let g:vim_json_syntax_conceal = v:true  " Enable conceal for json
let g:rust_conceal     = v:true " Conceal markers for rust
let g:vimsyn_embed = 'lPr' " Embed lua, python, and ruby in vim syntax.

" Keybindings {{{1

nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <space>g  :<C-u>CocList --normal gstatus<CR>

xmap ga         <Plug>(LiveEasyAlign)
nmap ga         <Plug>(EasyAlign)

" Trigger completion on menu key
inoremap <silent><expr> <F16> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    exe 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

nmap <silent> f <Plug>(coc-smartf-forward)
nmap <silent> F <Plug>(coc-smartf-backward)
nmap <silent> ; <Plug>(coc-smartf-repeat)
nmap <silent> , <Plug>(coc-smartf-repeat-opposite)

nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)

" Init augroup {{{1
aug init
  au!
  au FileType list setl nospell
  au FileType gitmessengerpopup setl winblend=10
  " Highlight symbol under cursor on CursorHold
  au CursorHold * silent call CocActionAsync('highlight')
  " Update signature help on jump placeholder
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  au CompleteDone * if pumvisible() == 0 | pclose | endif
aug END
" vim:ft=vim fenc=utf-8 fdm=marker
