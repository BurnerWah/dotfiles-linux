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

" Run any python code that our vimrc needs
py3 << EOF
import os
EOF

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
let dein#install_max_processes = py3eval('os.cpu_count()')

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

  " Helpful tools {{{2
  let s:gitlab = 'https://gitlab.com/'
  let s:gh_raw = 'https://raw.githubusercontent.com/'

  " Core plugins {{{2
  call dein#add('neoclide/coc.nvim', {
        \ 'if': (executable('node') &&
        \       (executable('npm') || executable('yarn'))),
        \ 'merged': v:false,
        \ 'rev': 'release',
        \ })

  call dein#add('Shougo/denite.nvim', {'if': has('python3'), 'merged': v:false})

  " Snippets & Templates {{{2
  " call dein#add('honza/vim-snippets')
  " vim-snippets is selectively linked in via stow

  " Language agnostic stuff {{{2
  " Polyglot used to be in here but it tends to break stuff so I don't use it
  " anymore.

  call dein#add('dense-analysis/ale', {'type__depth': 1})
  " Asynchronous linting engine

  " Language-specific stuff {{{2
  " CXX: {{{3
  call dein#add('jackguo380/vim-lsp-cxx-highlight', {
        \ 'if': (has('nvim') &&
        \       (executable('ccls') || executable('clangd') || executable('cquery'))),
        \ 'merged': v:true,
        \ })
  " Provides enhanced highlighting
  " It requires a compatible language server and a language client. The `if`
  " key handles checking for a compatible language server, but checking for a
  " language client isn't really possible.

  call dein#add('Shougo/neoinclude.vim')
  call dein#add('jsfaint/coc-neoinclude', {'depends': ['coc.nvim', 'neoinclude.vim']})
  " Provides completion for #include statements

  " Fish: {{{3
  " call dein#add('blankname/vim-fish')
  " Maintained fork of dag/vim-fish

  " Go: {{{3
  call dein#add('fatih/vim-go', {'if': has('nvim-0.3.2'), 'merged': v:true})

  " LLVM: {{{3
  call dein#add('rhysd/vim-llvm')
  " The llvm highlighting is in a subdirectory of llvm-mirror/llvm, which is a
  " 500mb repository. You're better off directly adding stuff or using a repo
  " based on it.
  " See: https://github.com/llvm-mirror/llvm/tree/master/utils/vim
  "
  " Has no plugin, so always merge.

  " Lua: {{{3
  call dein#add('bfredl/nvim-luadev')
  " Lua REPL
  " Plugin only adds a command and a few <Plug> mappings so it doesn't need to
  " be lazily loaded.

  " Markdown: {{{3
  call dein#add('iamcco/markdown-preview.nvim', {
        \ 'if': (executable('node') && executable('yarn')),
        \ 'lazy': v:true,
        \ 'on_ft': ['markdown', 'pandoc.markdown', 'rmd', 'vimwiki'],
        \ 'build': 'sh -c "cd app && yarn install --ignore-optional --link-duplicates"',
        \ })
  " Markdown live preview
  " Instructions suggest lazy loading with on_ft

  " Meson: {{{3
  call dein#add('mesonbuild/meson', {
        \ 'rtp': 'data/syntax-highlighting/vim',
        \ 'type__depth': 1,
        \ })
  " Official meson syntax is similar to the official llvm syntax, although we
  " can get the reposotory size down to about 21MB (at time of writing) by
  " cloning with a low depth.

  " Python: {{{3
  " I used to use python-mode but it turns out that plugin causes more problems
  " than it solves.

  call dein#add('vim-python/python-syntax')
  call dein#add('Vimjas/vim-python-pep8-indent')

  call dein#add('numirias/semshi', {'if': has('python3'), 'merged': v:true})
  " Provides semantic highlighting for Python code.
  " Probably will be replaced by tree sitter when nvim 0.5.0 releases

  call dein#add('bfredl/nvim-ipy', {
        \ 'if': has('python3'),
        \ 'merged': v:true,
        \ 'hook_post_source': join([
        \   'delcommand IPython2',
        \   'delcommand IJulia',
        \ ], "\n"),
        \ })
  " Python REPL
  " Dependency checking is kinda lackluster, but the simplest check if we can
  " import `jupyter_client` since everything else it seems to need can be
  " assumed to be installed.

  call dein#add('stsewd/isort.nvim', {
        \ 'if': (has('python3') && executable('isort')),
        \ 'merged': v:true,
        \ })
  " Remote plugin for isort
  " No plugin files, so don't load lazily.

  " Rust: {{{3

  call dein#add('rust-lang/rust.vim', {
        \ 'hook_post_source': join([
        \   'unlet g:syntastic_rust_checkers',
        \   'unlet g:syntastic_extra_filetypes',
        \ ], "\n"),
        \ })
  " Official rust syntax
  "
  " NOTE plugin/rust.vim doesn't do anything with my configuration.

  " call dein#add('mhinz/vim-crates')
  " Info on crates
  "
  " Not needed thanks to vim-package-info

  " VimL: {{{3
  call dein#add('Shougo/neco-vim')
  call dein#add('neoclide/coc-neco', {'depends': ['coc.nvim', 'neco-vim']})
  " VimL completion

  " Other: {{{3
  call dein#add('ekalinin/Dockerfile.vim')
  call dein#add('elzr/vim-json')
  call dein#add('leafo/moonscript-vim')
  call dein#add('cespare/vim-toml')
  call dein#add('arrufat/vala.vim', {
        \ 'hook_add': 'let g:loaded_vala_vim = 1',
        \ })

  call dein#add(s:gitlab.'HiPhish/awk-ward.nvim', {
        \ 'if': (has('nvim') && executable('awk')),
        \ 'merged': v:true,
        \ })

  " Integration: Work with other things {{{2
  " zealvim was removed because it was too aggressive with it's mappings
  " discord.nvim was removed because it often renders nvim inoperable

  call dein#add('editorconfig/editorconfig-vim') " editorconfig support
  call dein#add('tpope/vim-dadbod') " Access databases, etc.
  call dein#add('tpope/vim-fugitive')
  " git support
  " Fugitive resolves symlinks for git repos, which breaks a lot of random
  " stuff. If there's a way to fix that I'd be very happy but for now I'm just
  " not gonna use it.

  call dein#add('neoclide/denite-git', {'depends': ['denite.nvim']})

  call dein#add('rliang/termedit.nvim', {'if': has('python3'), 'merged': v:true})
  " Set $EDITOR to current nvim instance

  " Utilities {{{2
  call dein#add('vimwiki/vimwiki')
  call dein#add('liuchengxu/vista.vim', {'hook_add': 'cabbrev Vi Vista'})
  call dein#add('Vigemus/iron.nvim', {'if': has('nvim'), 'merged': v:true})
  " General REPL plugin

  call dein#add('fszymanski/fzf-gitignore', {
        \ 'if': (has('python3') && executable('fzf')),
        \ 'merged': v:true,
        \ })

  call dein#add('liuchengxu/vim-clap', {
        \ 'if': (has('nvim-0.4.2') && has('python3') && executable('cargo')),
        \ 'build': 'cd pythonx/clap; make build',
        \ 'hook_post_update': { -> clap#installer#download_binary() },
        \ })
  " Using a build step and a post update hook is inelegant as fuck, but it's
  " the fastest way to get clap up and running after an update. The build step
  " builds a python native library that improves performance by a lot, and the
  " post update hook downloads the binaries needed for clap to work. We could
  " build that locally but it takes a while and uses up a lot of space.
  " The lambda is there to minimize issues with post update hooks. Passing the
  " function to dein returns an error, and hooks are a little inconsistent.

  call dein#add('sakhnik/nvim-gdb', {
        \ 'if': (has('nvim') &&
        \       (executable('gdb') || executable('lldb') || executable('bashdb'))),
        \ 'merged': v:true,
        \ })

  " User interface {{{2
  call dein#add('ryanoasis/vim-devicons', {
        \ 'hook_post_source': join([
        \   'unlet g:NERDTreeUpdateOnCursorHold',
        \   'unlet g:NERDTreeGitStatusUpdateOnCursorHold',
        \ ], "\n"),
        \ })

  call dein#add('liuchengxu/vim-which-key', {
        \ 'lazy': v:true,
        \ 'on_cmd': ['WhichKey', 'WhichKey!', 'WhichKeyVisual', 'WhichKeyVisual!'],
        \ })
  " Show which keys are available in a pop-up

  call dein#add('rhysd/git-messenger.vim')
  " View git commit messages in a floating window.
  " Lazy loading is suggested in plugin readme, but performance benefit is
  " negligible.

  " At some point I'll add https://github.com/zgpio/tree.nvim to this, but for
  " the moment it won't install.

  " Denite {{{3
  call dein#add('notomo/denite-autocmd', {'depends': ['denite.nvim']})
  call dein#add('zacharied/denite-nerdfont', {'depends': ['denite.nvim']})
  call dein#add('neoclide/coc-denite', {'depends': ['denite.nvim', 'coc.nvim']})
  call dein#add('iyuuya/denite-ale', {'depends': ['denite.nvim', 'ale']})

  " Mode-line {{{3
  " I'm considering switching from airline over to something more neovim
  " oriented, or else over to lightline.
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes', {'depends': ['vim-airline']})

  " Visual helpers {{{3
  call dein#add('IMOKURI/line-number-interval.nvim') " Highlights line numbers

  call dein#add('norcalli/nvim-colorizer.lua', {'if': has('nvim-0.4.0'), 'merged': v:true})
  " Highlights colors really quickly.

  call dein#add('meain/vim-package-info', {
        \ 'if': (has('node') && executable('yarn')),
        \ 'build': 'yarn install --ignore-optional --link-duplicates',
        \ })
  " Shows package information in package.json, cargo.toml, etc.
  " Very simple plugin right now, no need to lazy-load.

  " Signcolumn {{{3
  " call dein#add('airblade/vim-gitgutter')
  call dein#add('mhinz/vim-signify')

  " Color schemes {{{3
  " call dein#add('tyrannicaltoucan/vim-quantum')
  call dein#add('morhetz/gruvbox')

  " Text-editing {{{2
  call dein#add('tpope/vim-abolish')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-speeddating')
  call dein#add('farmergreg/vim-lastplace') " Open files where last editing them
  call dein#add('AndrewRadev/splitjoin.vim')
  call dein#add('junegunn/vim-easy-align')
  " Align text to certain characters.
  " Can be loaded lazily, but performance benefit is negligible

  " call dein#add('meain/vim-colorswitch', {'if': has('python3'), 'merged': v:true})
  " Cycle between hex, rgb, and hsl colors

  " Required {{{2
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syn enable


" Plugin Settings {{{1

let snips_author = 'Jaden Pleasants'
let snips_email  = 'jadenpleasants@fastmail.com'
let EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

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
      \ 'c': ['ccls', 'clangd'],
      \ 'cpp': ['ccls', 'clangd'],
      \ 'css': ['stylelint'],
      \ 'fortran': ['language_server'],
      \ 'go': ['golangserver', 'gopls'],
      \ 'javascript': ['tsserver'],
      \ 'less': ['stylelint'],
      \ 'lua': ['luacheck'],
      \ 'markdown': ['markdownlint'],
      \ 'nim': ['nimlsp'],
      \ 'objc': ['ccls', 'clangd'],
      \ 'objcpp': ['clangd'],
      \ 'python': ['flake8', 'mypy', 'pyls', 'pylint'],
      \ 'rust': ['rls'],
      \ 'sass': ['stylelint'],
      \ 'scss': ['stylelint'],
      \ 'sh': ['language_server', 'shellcheck'],
      \ 'tex': ['texlab'],
      \ 'typescript': ['tsserver'],
      \ 'vim': ['vint'],
      \ 'yaml': ['yamllint'],
      \ }

let ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'cmake': ['cmakeformat', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'cpp': [
      \   'clang-format',
      \   'clangtidy',
      \   'remove_trailing_lines',
      \   'trim_whitespace',
      \ ],
      \ 'go': [
      \   'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace',
      \ ],
      \ 'html': ['tidy', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'less': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'python': [
      \   'add_blank_lines_for_python_control_statements',
      \   'reorder-python-imports',
      \   'remove_trailing_lines',
      \   'trim_whitespace',
      \ ],
      \ 'rust': ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'scss': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'sh': ['shfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'sql': ['sql-format', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'xml': ['xmllint'],
      \ }

let ale_linter_aliases = {
      \ 'jsonc': 'json',
      \ }

let ale_javascript_prettier_options = join([
      \ '--no-semi',
      \ '--single-quote',
      \ ])

let ale_sh_shfmt_options = join(['-i=2', '-ci'])

" VimWiki: Note-taking tool {{{2
let vimwiki_list = [{
      \ 'path': '~/Documents/VimWiki',
      \ 'nested_syntaxes': {'c++': 'cpp', 'python': 'python',},
      \ }]

" Vista: replacement for tagbar {{{2
let vista#renderer#enable_icon = 1
let vista_executive_for = {
      \ 'c': 'coc',
      \ 'cpp': 'coc',
      \ 'css': 'coc',
      \ 'go': 'coc',
      \ 'html': 'coc',
      \ 'javascript': 'coc',
      \ 'json': 'coc',
      \ 'lua': 'coc',
      \ 'markdown': 'toc',
      \ 'pandoc': 'markdown',
      \ 'python': 'coc',
      \ 'tex': 'coc',
      \ 'typescript': 'coc',
      \ 'vala': 'coc',
      \ 'vim': 'coc',
      \ 'vimwiki': 'markdown',
      \ 'xml': 'coc',
      \ 'yaml': 'coc',
      \ }
let vista_ctags_cmd = get(g:, 'vista_ctags_cmd', {}) " This isn't set by default
if executable('gotags')
  let vista_ctags_cmd.go = 'gotags'
endif

" Other: {{{2
let neoinclude#max_processes = py3eval('os.cpu_count()')

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

" Keybindings {{{1

inor <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inor <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnor <silent> <space>g  :<C-u>CocList --normal gstatus<CR>

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(EasyAlign)

" Trigger completion on menu key
inor <silent><expr> <F16> coc#refresh()

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
  au VimEnter * call dein#call_hook('post_source')
aug END
" vim:ft=vim fenc=utf-8 fdm=marker
