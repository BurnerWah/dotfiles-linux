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
set updatetime  =300
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

let node_host_prog = exepath('neovim-node-host')
let ruby_host_prog = exepath('neovim-ruby-host')
let fennel_nvim_auto_init = v:false

" Maybe someday I'll be able to remove this block
if &shell =~# 'fish$'
  set shell=bash
endif

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
let dein#install_log_filename = stdpath('data').'/logs/dein.log'
let dein#enable_notification = v:true
let dein#install_progress_type = 'tabline'

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
  let s:gh_raw = 'https://raw.githubusercontent.com/'

  " Core plugins {{{2
  call dein#add('neoclide/coc.nvim', {
        \ 'if': (executable('node') &&
        \       (executable('npm')  ||
        \       (executable('yarn') || executable('yarnpkg')))),
        \ 'merged': v:false,
        \ 'rev': 'release',
        \ })

  call dein#add('Shougo/denite.nvim', {'if': has('python3'), 'merged': v:false})

  call dein#add('neoclide/coc-denite', {'depends': ['denite.nvim', 'coc.nvim']})

  " Snippets & Templates {{{2
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
  " FTDetect: $VIMRUNTIME
  " FTPlugin: $VIMRUNTIME
  " Syntax: $VIMRUNTIME
  " Format: $VIMRUNTIME
  " Linter: ALE
  " Snippets: vim-snippets

  call dein#add(s:gitlab.'HiPhish/awk-ward.nvim', {
        \ 'if': (has('nvim') && executable('awk')),
        \ 'merged': v:true,
        \ })

  " CXX: {{{3
  " FTDetect: $VIMRUNTIME
  " FTPlugin: $VIMRUNTIME
  " Syntax: chromatica.nvim, $VIMRUNTIME
  " Format: ALE, language server, $VIMRUNTIME
  " Linter: ALE, language server
  " Completion: language server, neoinclude
  " Snippets: vim-snippets

  call dein#add('arakashic/chromatica.nvim', {
        \ 'if': has('python3'),
        \ 'merged': v:true,
        \ })
  " Provides enhanced highlighting. It requires the base CXX syntax definition.

  call dein#add('Shougo/neoinclude.vim')
  call dein#add('jsfaint/coc-neoinclude', {
        \ 'depends': ['coc.nvim', 'neoinclude.vim'],
        \ })

  " Docker: dockerfile, docker-compose {{{3
  " FTDetect: Dockerfile.vim
  " FTPlugin: Dockerfile.vim
  " Syntax: Dockerfile.vim
  " Format: Dockerfile.vim
  " Linter: ALE, language server
  " Completion: language server
  " Snippets: Dockerfile.vim

  call dein#add('ekalinin/Dockerfile.vim')

  " Fish: {{{3
  " call dein#add('blankname/vim-fish')
  " Maintained fork of dag/vim-fish

  " Go: {{{3
  " FTDetect: vim-go, $VIMRUNTIME
  " FTPlugin: vim-go
  " Syntax: vim-go
  " Format: ALE, vim-go
  " Linter: ALE, vim-go?
  " Completion: language server
  " Snippets: vim-go, vim-snippets
  " Compiler: vim-go

  call dein#add('fatih/vim-go', {
        \ 'if': has('nvim-0.3.2'),
        \ 'merged': v:true,
        \ })

  " I3: {{{3
  call dein#add('mboughaba/i3config.vim')

  " JSON: {{{3
  " FTDetect: vim-json, $VIMRUNTIME
  " FTPlugin: vim-json
  " Syntax: vim-json, custom
  " Format: coc-json, ALE, vim-json
  " Linter: coc-json, ALE, vim-json
  " Completion: coc-json
  " Snippets: coc-json
  call dein#add('elzr/vim-json')

  " LLVM: {{{3
  " The llvm highlighting is in a subdirectory of llvm-mirror/llvm, which is a
  " 500mb repository. You're better off directly adding stuff or using a repo
  " based on it.
  " See: https://github.com/llvm-mirror/llvm/tree/master/utils/vim

  call dein#add('rhysd/vim-llvm')

  " Lua: {{{3
  call dein#add('bfredl/nvim-luadev')

  " Markdown: {{{3
  call dein#add('iamcco/markdown-preview.nvim', {
        \ 'if': executable('node'),
        \ 'lazy': v:true,
        \ 'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
        \ 'build': 'sh -c "cd app && yarn install --ignore-optional --link-duplicates"',
        \ })

  " Meson: {{{3
  " Official meson syntax is similar to the official llvm syntax, although we
  " can get the reposotory size down to about 21MB (at time of writing) by
  " cloning with a low depth.
  call dein#add('mesonbuild/meson', {
        \ 'rtp': 'data/syntax-highlighting/vim',
        \ 'type__depth': 1,
        \ })

  " MoonScript: {{{3
  call dein#add('leafo/moonscript-vim')

  " call dein#add('svermeulen/nvim-moonmaker', {'merged': v:false})
  " This plugin deletes files in it's lua dir, so we can't safely merge it.

  " Powershell: {{{3
  call dein#add('PProvost/vim-ps1')

  " Python: {{{3
  " FTDetect: $VIMRUNTIME
  " FTPlugin: $VIMRUNTIME
  " Syntax: Semshi, python-syntax
  " Format: ALE, language server, isort.nvim
  " Linter: ALE, language server, coc-pyright
  " Completion: language server
  " Snippets: vim-snippets
  " I used to use python-mode but it turns out that plugin causes more problems
  " than it solves.

  call dein#add('vim-python/python-syntax')
  call dein#add('Vimjas/vim-python-pep8-indent')

  call dein#add('numirias/semshi', {'if': has('python3'), 'merged': v:true})
  " Semshi provides semantic highlighting for Python code.

  call dein#add('bfredl/nvim-ipy', {'if': has('python3'), 'merged': v:true})
  call dein#add('stsewd/isort.nvim', {
        \ 'if': (has('python3') && executable('isort')),
        \ 'merged': v:true,
        \ })

  " QML: {{{3
  call dein#add('peterhoeg/vim-qml')

  " Rust: {{{3
  " FTDetect: rust.vim
  " FTPlugin: rust.vim
  " Syntax: rust.vim
  " Format: rust.vim, ale, coc-rls?
  " Linter: ale, coc-rls
  " Completion: coc-rls
  " Snippets: vim-snippets, coc-rls

  call dein#add('rust-lang/rust.vim')
  " Official rust syntax

  " call dein#add('mhinz/vim-crates')
  " Info on crates

  " TeX: {{{3
  " FTDetect: $VIMRUNTIME
  " FTPlugin: vimtex
  " Syntax: vimtex
  " Linter: ALE, coc-texlab
  " Completion: coc-texlab, coc-vimtex
  " Snippets: vim-snippets, coc-texlab?
  " There isn't a good way to install gillescastel/latex-snippets so I'm not
  " using it right now.
  call dein#add('lervag/vimtex', {'type__depth': 1})

  " TOML: {{{3
  call dein#add('cespare/vim-toml')

  " Vala: {{{3
  call dein#add('arrufat/vala.vim')

  " VimL: {{{3
  call dein#add('Shougo/neco-vim')
  call dein#add('neoclide/coc-neco', {'depends': ['coc.nvim', 'neco-vim']})

  " Zsh: {{{3
  " Syntax: mine
  " Completion: coc-zsh

  " For the most part, I'm using a heavily modified version of the Zsh syntax.
  call dein#add('tjdevries/coc-zsh', {
        \ 'if': executable('zsh'),
        \ 'depends': ['coc.nvim'],
        \ 'merged': v:true,
        \ })
  " Zsh completions in Zsh scripts.

  " Integration: Work with other things {{{2
  " zealvim was removed because it was too agressive with it's mappings

  call dein#add('tpope/vim-fugitive')
  " Fugitive resolves symlinks for git repos, which breaks a lot of random
  " stuff. If there's a way to fix that I'd be very happy but for now I'm just
  " not gonna use it.

  call dein#add('tpope/vim-dadbod')

  call dein#add('neoclide/denite-git', {'depends': ['denite.nvim']})
  call dein#add('Vigemus/iron.nvim')
  " call dein#add('aurieh/discord.nvim')
  " This seems to make nvim segfault sometimes

  " General utilities {{{2
  call dein#add('vimwiki/vimwiki')
  " call dein#add('dunstontc/projectile.nvim', {'depends': ['denite.nvim']})
  call dein#add('Vigemus/nvimux')
  call dein#add('liuchengxu/vim-clap', {
        \ 'if': (has('nvim-0.4.2') && has('python3') && executable('cargo')),
        \ 'build': join([
        \   'cargo build --release',
        \   'cd pythonx/clap',
        \   'make build',
        \ ], ';'),
        \ })
  call dein#add('liuchengxu/vista.vim')

  " User interface {{{2
  call dein#add('ryanoasis/vim-devicons')
  " call dein#add('Shougo/deol.nvim', {'depends': ['denite.nvim']})
  call dein#add('notomo/denite-autocmd', {'depends': ['denite.nvim']})
  call dein#add('zacharied/denite-nerdfont', {'depends': ['denite.nvim']})
  call dein#add('sakhnik/nvim-gdb', {
        \ 'if': (has('python3')     &&
        \       (executable('gdb')  ||
        \        executable('lldb') ||
        \        executable('bashdb'))),
        \ 'merged': v:true,
        \ })
  call dein#add('liuchengxu/vim-which-key')
  call dein#add('camspiers/animate.vim')
  call dein#add('camspiers/lens.vim')

  call dein#add('rhysd/git-messenger.vim', {
        \ 'lazy': v:true,
        \ 'on_cmd': 'GitMessenger',
        \ 'on_map': '<Plug>(git-messenger',
        \ })
  " View git commit messages in a floating window.

  " At some point I'll add https://github.com/zgpio/tree.nvim to this, but for
  " the moment it won't install.

  " Mode-line {{{3
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes', {'depends': ['vim-airline']})

  " Visual helpers {{{3
  let g:line_number_interval#enable_at_startup = v:true
  call dein#add('IMOKURI/line-number-interval.nvim')

  call dein#add('norcalli/nvim-colorizer.lua')
  " nvim colorizer highlights colors really quickly.

  call dein#add('meain/vim-package-info', {
        \ 'if': has('node'),
        \ 'build': 'yarn install --ignore-optional --link-duplicates',
        \ })
  " Shows package information in package.json, cargo.toml, etc.
  " Very simple plugin right now, no need to lazy-load.

  " Signcolumn {{{3
  " call dein#add('airblade/vim-gitgutter')
  call dein#add('mhinz/vim-signify')

  " Color schemes {{{3
  " call dein#add('keitanakamura/neodark.vim')
  " call dein#add('tyrannicaltoucan/vim-quantum')
  call dein#add('morhetz/gruvbox')
  " call dein#add('liuchengxu/space-vim-theme',)
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
  " call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('rliang/termedit.nvim')
  call dein#add('fszymanski/fzf-gitignore')
  call dein#add('editorconfig/editorconfig-vim')
  " call dein#add('Shougo/context_filetype.vim')
  " call dein#add('easymotion/vim-easymotion')

  " call dein#add('Yggdroot/LeaderF', {
  "       \ 'merged': v:true,
  "       \ 'build': 'bash install.sh',
  "       \ })

  " call dein#add('Shougo/vimproc.vim', {
  "       \ 'merged': v:true,
  "       \ 'build': 'make && strip lib/vimproc_linux64.so',
  "       \ })

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

" Plugin Settings {{{1

let snips_author = 'Jaden Pleasants'
let snips_email  = 'jadenpleasants@fastmail.com'
let git_messenger_always_into_popup = v:true
let EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

lua require("navigation")

exe 'luafile '.stdpath('config').'/config.lua'

" Colorscheme: Currently set to a fork of quantum {{{2
set background=dark
let quantum_black   = v:true
let quantum_italics = v:true

colors quantum

" Airline: Bottom bar for Vim. {{{2

" Main settings
let airline_powerline_fonts  = v:true " Airline + Powerline
let airline_detect_spelllang = v:false " Cleans up stuff a little
" let airline_inactive_collapse = 1
let airline_skip_empty_sections = 1

" Extensions

let airline#extensions#tabline#enabled   = v:true " airline tabs
let airline#extensions#tabline#formatter = 'unique_tail_improved'

" ALE: Async linter {{{2
let ale_fix_on_save = v:true

let ale_linters_ignore = {
      \   'c': ['ccls', 'clangd'],
      \   'cpp': ['ccls', 'clangd'],
      \   'css': ['stylelint'],
      \   'fortran': ['language_server'],
      \   'go': ['golangserver', 'gopls'],
      \   'javascript': ['tsserver'],
      \   'less': ['stylelint'],
      \   'lua': ['luacheck'],
      \   'markdown': ['markdownlint'],
      \   'nim': ['nimlsp'],
      \   'objc': ['ccls', 'clangd'],
      \   'objcpp': ['clangd'],
      \   'python': ['flake8', 'mypy', 'pyls', 'pylint'],
      \   'rust': ['rls'],
      \   'sass': ['stylelint'],
      \   'scss': ['stylelint'],
      \   'sh': ['language_server', 'shellcheck'],
      \   'tex': ['texlab'],
      \   'typescript': ['tsserver'],
      \   'vim': ['vint'],
      \   'yaml': ['yamllint'],
      \ }

let ale_fixers = {
      \   '*': [
      \     'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'cmake': [
      \     'cmakeformat', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'cpp': [
      \     'clang-format',
      \     'clangtidy',
      \     'remove_trailing_lines',
      \     'trim_whitespace',
      \   ],
      \   'go': [
      \     'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'html': [
      \     'tidy', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'less': [
      \     'prettier', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'python': [
      \     'add_blank_lines_for_python_control_statements',
      \     'reorder-python-imports',
      \     'remove_trailing_lines',
      \     'trim_whitespace',
      \   ],
      \   'rust': [
      \     'rustfmt', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'scss': [
      \     'prettier', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'sh': [
      \     'shfmt', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'sql': [
      \     'sql-format', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'xml': [
      \     'xmllint',
      \   ],
      \ }

let ale_linter_aliases = {
      \   'jsonc': 'json',
      \ }

let ale_javascript_prettier_options = join([
      \ '--no-semi',
      \ '--single-quote',
      \ ])

let ale_sh_shfmt_options = join([
      \ '-i=2',
      \ '-ci',
      \ ])

" Chromatica: Remote plugin that enhances clang highlighting {{{2
let chromatica#libclang_path     = '/usr/lib64/libclang.so'
let chromatica#enable_at_startup = v:true " auto-enable Chromatica when relevant
let chromatica#responsive_mode   = v:true " Continuously highlight files
" Without the following args, chromatica won't highlight files correctly.
let chromatica#global_args = [
      \ '-isystem/usr/include/c++/9',
      \ '-isystem/usr/include/c++/9/x86_64-redhat-linux',
      \ '-isystem/usr/include/c++/9/backward',
      \ '-isystem/usr/lib64/clang/9.0.1/include',
      \ '-isystem/usr/local/include',
      \ ]

" Lens: Automatic Window Resizing {{{2
let lens#disabled_filetypes = [
      \   'list',
      \   'qf',
      \   'vista',
      \ ]

" VimWiki: Note-taking tool {{{2
let vimwiki_list = [{
      \   'path': '~/Documents/VimWiki',
      \   'nested_syntaxes': {'c++': 'cpp', 'python': 'python',},
      \ }]

" Vista: replacement for tagbar {{{2
let vista#renderer#enable_icon = 1
let vista_executive_for = {
      \   'c': 'coc',
      \   'cpp': 'coc',
      \   'css': 'coc',
      \   'go': 'coc',
      \   'html': 'coc',
      \   'javascript': 'coc',
      \   'json': 'coc',
      \   'lua': 'coc',
      \   'markdown': 'toc',
      \   'python': 'coc',
      \   'tex': 'coc',
      \   'typescript': 'coc',
      \   'vala': 'coc',
      \   'xml': 'coc',
      \   'yaml': 'coc',
      \ }
let vista_ctags_cmd = {
      \   'go': 'gotags',
      \ }

" Syntax Settings {{{1
" Go
let go_code_completion_enabled         = v:false " Let coc handle completion
let go_def_mapping_enabled             = v:false
let go_doc_keywordprg_enabled          = v:false
let go_highlight_build_constraints     = v:true
let go_highlight_extra_types           = v:true
let go_highlight_fiels                 = v:true
let go_highlight_function_calls        = v:true
let go_highlight_function_parameters   = v:true
let go_highlight_functions             = v:true
let go_highlight_generate_tags         = v:true
let go_highlight_operators             = v:true
let go_highlight_types                 = v:true
let go_highlight_variable_assingments  = v:true
let go_highlight_variable_declarations = v:true
let go_textobj_enabled                 = v:false

" JSON
let vim_json_syntax_conceal = v:true  " Enable conceal for json

" Python
let python_highlight_all = 1

" Tex
let tex_flavor = 'latex'

" VimL
let vimsyn_embed = 'lPr' " Embed lua, python, and ruby in vim syntax.

" Markdown
let markdown_fenced_languages = ['go']

" Commands {{{1
cabbrev Vi Vista

" Keybindings {{{1

nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> <space>g  :<C-u>CocList --normal gstatus<CR>

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(EasyAlign)

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

" nmap <silent> f <Plug>(coc-smartf-forward)
" nmap <silent> F <Plug>(coc-smartf-backward)
" nmap <silent> ; <Plug>(coc-smartf-repeat)
" nmap <silent> , <Plug>(coc-smartf-repeat-opposite)

" nmap <silent> <C-c> <Plug>(coc-cursors-position)
" nmap <silent> <C-d> <Plug>(coc-cursors-word)
" xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)

" Init augroup {{{1
aug init
  au!
  au FileType list setl nospell
  au FileType gitmessengerpopup setl winblend=10
  " Update signature help on jump placeholder
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  au CompleteDone * if pumvisible() == 0 | pclose | endif
aug END
" vim:ft=vim fenc=utf-8 fdm=marker
