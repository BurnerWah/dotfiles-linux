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
syn enable             " Enable syntax highlighting.

set expandtab          " Use spaces instead of tabs.
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
" Spell is disabled until nvim-treesitter#698 is resolved. It should still be
" usable on filetypes without treesitter support.
" set spell              " Enable spell correction
set spelllang   =en_us " Set language for spelling
set pumblend    =10    " Slightly transparent menus
set sessionoptions  =blank,curdir,folds,help,localoptions,tabpages,winpos,winsize
set updatetime  =300
set list               " Show non-printable characters.
if ( has('multi_byte') && &encoding ==# 'utf-8' )
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:-'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:+,trail:-'
endif
if has('conceal')
  set conceallevel  =2
  set concealcursor =nv
endif

let [g:loaded_python_provider, g:loaded_perl_provider] = [0, 0]
let node_host_prog = exepath('neovim-node-host')
let ruby_host_prog = exepath('neovim-ruby-host')

" Fish can cause problems with plugins
let &shell = (&shell =~# 'fish$') ? 'bash' : &shell

let g:gitblame_enabled = 0 " Mitigation for #11

" Load python utilities
exe printf('py3file %s/util.py', stdpath('config'))

" Dein: plugin manager {{{1
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
  call dein#add('neoclide/coc.nvim', #{ if: executable('npm'), rev: 'release' })
  call dein#add('Shougo/denite.nvim', #{ if: has('python3'), type__depth: 1 })

  " Snippets & Templates {{{2
  " call dein#add('honza/vim-snippets')
  " vim-snippets is selectively linked in via stow

  " Language agnostic stuff {{{2
  " Polyglot used to be in here but it tends to break stuff so I don't use it
  " anymore.

  call dein#add('dense-analysis/ale', #{ type__depth: 1 }) " Asynchronous linting engine

  call dein#add('nvim-treesitter/nvim-treesitter', #{
        \ if: ( has('nvim-0.5.0') && executable('cc') ),
        \ })
  call dein#add('nvim-treesitter/nvim-treesitter-refactor', #{ depends: 'nvim-treesitter' })
  call dein#add('nvim-treesitter/nvim-treesitter-textobjects', #{ depends: 'nvim-treesitter' })
  call dein#add('nvim-treesitter/playground', #{ depends: 'nvim-treesitter' })
  call dein#add('p00f/nvim-ts-rainbow', #{ depends: 'nvim-treesitter' })

  " Language-specific stuff {{{2
  " CXX: {{{3
  call dein#add('jackguo380/vim-lsp-cxx-highlight', #{
        \ if: ( executable('ccls') || executable('clangd') ),
        \ merged: v:true,
        \ })
  " Provides enhanced highlighting

  call dein#add('Shougo/neoinclude.vim') " Provides completion for #include statements
  call dein#add('jsfaint/coc-neoinclude', #{ depends: ['coc.nvim', 'neoinclude.vim'] })

  " Fish: {{{3
  " call dein#add('blankname/vim-fish')
  " Maintained fork of dag/vim-fish

  " Lua: {{{3
  call dein#add('euclidianAce/BetterLua.vim')
  call dein#add('tjdevries/manillua.nvim')
  call dein#add('rafcamlet/nvim-luapad')
  call dein#add('rafcamlet/coc-nvim-lua', #{ depends: 'coc.nvim' })
  call dein#add('tjdevries/nlua.nvim')
  call dein#add('bfredl/nvim-luadev') " Lua REPL
  " Plugin only adds a command and a few <Plug> mappings so it doesn't need to
  " be lazily loaded.

  " Markdown: {{{3
  call dein#add('npxbr/glow.nvim') " GlowInstall hook broke dein
  call dein#add('iamcco/markdown-preview.nvim', #{
        \ if: executable('yarn'),
        \ lazy: v:true,
        \ on_ft: ['markdown', 'pandoc.markdown', 'rmd', 'vimwiki'],
        \ build: 'sh -c "cd app && yarn install"',
        \ type__depth: 1,
        \ })
  " Markdown live preview
  " Instructions suggest lazy loading with on_ft

  " Meson: {{{3
  call dein#add('mesonbuild/meson', #{
        \ rtp: 'data/syntax-highlighting/vim',
        \ type__depth: 1,
        \ })
  " Official meson syntax is similar to the official llvm syntax, although we
  " can get the reposotory size down to about 21MB (at time of writing) by
  " cloning with a low depth.

  " Moonscript: {{{3
  call dein#add('leafo/moonscript-vim')
  call dein#add('svermeulen/nvim-moonmaker', #{ merged: v:false })
  " nvim-moonmaker can't be safely merged, as it'll delete merged lua files.

  " Python: {{{3
  " I used to use python-mode but it turns out that plugin causes more problems
  " than it solves.
  " stsewd/isort.nvim has issues

  call dein#add('vim-python/python-syntax')
  call dein#add('Vimjas/vim-python-pep8-indent')

  call dein#add('numirias/semshi', #{ if: has('python3'), merged: v:true })
  " Provides semantic highlighting for Python code.
  " Probably will be replaced by tree sitter when nvim 0.5.0 releases

  call dein#add('bfredl/nvim-ipy', #{
        \ if: ( has('python3') && py3eval('has_module("jupyter_client")') ),
        \ merged: v:true,
        \ hook_add: 'let g:nvim_ipy_perform_mappings = 0',
        \ hook_post_source: join([
        \   'delcommand IPython2',
        \   'delcommand IJulia',
        \ ], "\n"),
        \ })
  " Python REPL

  " VimL: {{{3
  call dein#add('Shougo/neco-vim') " VimL completion
  call dein#add('neoclide/coc-neco', #{ depends: ['coc.nvim', 'neco-vim'] })

  " Other: {{{3
  call dein#add('rhysd/vim-llvm') " Mirror of syntax from llvm repo
  call dein#add('rust-lang/rust.vim') " Official rust syntax
  call dein#add('elzr/vim-json')
  call dein#add('cespare/vim-toml')
  call dein#add('arrufat/vala.vim')
  call dein#add('ron-rs/ron.vim')
  call dein#add('bakpakin/fennel.vim')
  call dein#add('aklt/plantuml-syntax')
  call dein#add('tikhomirov/vim-glsl')
  call dein#add('udalov/kotlin-vim')
  call dein#add('jparise/vim-graphql')
  call dein#add('tomlion/vim-solidity')
  call dein#add('evanleck/vim-svelte')
  call dein#add('YaBoiBurner/requirements.txt.vim') " Fork of raimon49/requirements.txt.vim
  call dein#add('YaBoiBurner/vim-teal') " Fork of teal-language/vim-teal

  call dein#add(s:gitlab.'HiPhish/awk-ward.nvim', #{ if: executable('awk'), merged: 1 })
  call dein#add('stsewd/sphinx.nvim', #{ if: has('python3') })
  " Improvements to RST

  " Integration: Work with other things {{{2
  call dein#add('romgrk/todoist.nvim', #{ if: has('node'), build: 'npm i' })
  call dein#add('editorconfig/editorconfig-vim') " editorconfig support
  call dein#add('tpope/vim-dadbod') " Access databases, etc.
  call dein#add('tpope/vim-fugitive') " git support
  call dein#add('f-person/git-blame.nvim')
  call dein#add('yuki-ycino/fzf-preview.vim', #{
        \ if: ( has('node') && executable('fzf') ),
        \ rev: 'release',
        \ })

  call dein#add('rliang/termedit.nvim', #{ if: has('python3'), merged: v:true })
  " Set $EDITOR to current nvim instance

  " Utilities {{{2
  " removed fzf-gitignore because it has an unintuitive bug
  call dein#add('haya14busa/dein-command.vim') " Commands for Dein
  call dein#add('vimwiki/vimwiki')
  call dein#add('liuchengxu/vista.vim', #{ hook_add: 'cabbrev Vi Vista' })
  call dein#add('Vigemus/iron.nvim') " General REPL plugin

  call dein#add('liuchengxu/vim-clap', #{
        \ if: ( has('python3') && executable('cargo') ),
        \ build: 'make python-dynamic-module',
        \ hook_post_update: 'call clap#installer#force_download()',
        \ })
  call dein#add('vn-ki/coc-clap', #{ depends: ['coc.nvim', 'vim-clap'] })

  call dein#add('sakhnik/nvim-gdb', #{
        \ if: ( has('python3') && ( executable('gdb') || executable('lldb') ) ),
        \ merged: v:true,
        \ hook_add: 'let g:nvimgdb_disable_start_keymaps = 1',
        \ hook_post_source: join([
        \   'delcommand GdbStartBashDB'
        \ ], "\n")
        \ })
  " Debugging plugin
  " We don't bother checking for `bashdb` since it's unlikely that it's the
  " only debugger installed.

  " User interface {{{2
  " At some point I'll add https://github.com/zgpio/tree.nvim to this, but for
  " the moment it won't install.

  call dein#add('kyazdani42/nvim-web-devicons')
  call dein#add('ryanoasis/vim-devicons', #{
        \ hook_add: 'let g:webdevicons_enable_nerdtree = 0',
        \ hook_post_source: join([
        \   'unlet! '.join([
        \     'g:NERDTreeGitStatusUpdateOnCursorHold',
        \     'g:NERDTreeUpdateOnCursorHold',
        \     'g:WebDevIconsNerdTreeBeforeGlyphPadding',
        \     'g:WebDevIconsNerdTreeAfterGlyphPadding',
        \     'g:WebDevIconsNerdTreeGitPluginForceVAlign',
        \     'g:webdevicons_conceal_nerdtree_brackets',
        \   ]),
        \   'delfu! NERDTreeWebDevIconsRefreshListener',
        \ ], "\n"),
        \ type__depth: 1,
        \ })
  " devicons doesn't check if nerdtree is installed before configuring a lot
  " of it, so it pollutes our setup with a bunch of unnecessary things to
  " remove.
  " Honestly devicons just has way too many variables.

  call dein#add('rhysd/git-messenger.vim')
  " View git commit messages in a floating window.
  " Lazy loading is suggested in plugin readme, but performance benefit is
  " negligible.

  call dein#add('wfxr/minimap.vim', #{
        \ if: ( has('nvim-0.5.0') && executable('code-minimap') ),
        \ merged: v:true,
        \ })
  call dein#add('kyazdani42/nvim-tree.lua', #{
        \ if: has('nvim-0.5.0'),
        \ depends: 'nvim-web-devicons',
        \ merged: v:true,
        \ })

  " Denite {{{3
  call dein#add('neoclide/denite-git', #{ depends: 'denite.nvim' })
  call dein#add('notomo/denite-autocmd', #{ depends: 'denite.nvim' })
  call dein#add('zacharied/denite-nerdfont', #{ depends: 'denite.nvim' })
  call dein#add('neoclide/coc-denite', #{ depends: ['denite.nvim', 'coc.nvim'] })
  call dein#add('iyuuya/denite-ale', #{ depends: ['denite.nvim', 'ale'] })

  " Mode-line {{{3
  " I'm considering switching from airline over to something more neovim
  " oriented, or else over to lightline.
  call dein#add('vim-airline/vim-airline', #{ merged: v:false })
  call dein#add('vim-airline/vim-airline-themes', #{ depends: 'vim-airline' })

  " call dein#add('romgrk/barbar.nvim', {'if': has('nvim-0.5.0'), 'merged': 1})
  " Barbar is bugged in problematic ways. At time of writing, filetype icons
  " have broken highlighting, and opening Vista often breaks barbar. It also
  " will get stuck not knowing what buffer you're on at times.
  " Once fixed, it'll replace airline's tab bar.

  " Visual helpers {{{3
  call dein#add('IMOKURI/line-number-interval.nvim') " Highlights line numbers
  call dein#add('norcalli/nvim-colorizer.lua') " Highlights colors quickly.

  call dein#add('meain/vim-package-info', #{ if: has('node'), build: 'npm i' })
  " Shows package information in package.json, cargo.toml, etc.
  " Very simple plugin right now, no need to lazy-load.

  " Signcolumn {{{3
  " call dein#add('airblade/vim-gitgutter')
  call dein#add('mhinz/vim-signify')

  " Color schemes {{{3
  call dein#add('tjdevries/colorbuddy.nvim', #{ if: has('nvim-0.5.0'), merged: 1 })
  call dein#add('tyrannicaltoucan/vim-quantum')
  " I'm using a colorbyddy implementation of this theme, but it's useful to
  " include the original theme to get some of the resources from it.

  " Text-editing {{{2
  call dein#add('tpope/vim-abolish') " Language friendly searches, substitutions, and abbreviations
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-surround') " Plugin for deleting, changing, and adding 'surroundings'
  call dein#add('tpope/vim-commentary') " Comment stuff out
  call dein#add('tpope/vim-repeat') " Let the repeat command repeat plugin maps
  call dein#add('tpope/vim-speeddating') " use CTRL-A/CTRL-X to increment dates, times, and more
  call dein#add('farmergreg/vim-lastplace') " Open files where last editing them
  call dein#add('AndrewRadev/splitjoin.vim')
  call dein#add('junegunn/vim-easy-align') " Align text to certain characters.

  call dein#add('meain/vim-colorswitch', #{
        \ if: ( has('python3') && py3eval('has_module("colour")') ),
        \ merged: v:true,
        \ })
  " Cycle between hex, rgb, and hsl colors

  " Required {{{2
  call dein#end()
  call dein#save_state()
endif

syn enable


" Cleanup {{{1
" This is just to get rid of weird stuff that shouldn't be created with my
" configuration. We delay them with an autocmd group since directly calling
" them seems to do nothing.
" autocommands should always hare the ++once flag here as a safety measure,
" and commands should generally be prefixed with sil! so they don't cause any
" errors.
aug init_cleanup
  au!
  au VimEnter * ++once sil! unlet
        \ g:syntastic_extra_filetypes
        \ g:syntastic_rust_checkers g:syntastic_vala_checkers
aug END

" Plugin Settings {{{1

let coc_filetype_map = #{ catalog: 'xml', dtd: 'xml', vimwiki: 'markdown', smil: 'xml', xsd: 'xml' }
let snips_author = 'Jaden Pleasants'
let snips_email  = 'jadenpleasants@fastmail.com'
let EditorConfig_exclude_patterns = ['fugitive://.\*', 'output://.\*', 'scp://.\*', 'term://.\*']
let minimap_block_filetypes = [
      \ 'ale-fix-suggest',
      \ 'ale-preview-selection',
      \ 'ale-preview',
      \ 'coc-explorer',
      \ 'denite',
      \ 'denite-filter',
      \ 'fugitive',
      \ 'nerdtree',
      \ 'list',
      \ 'LuaTree',
      \ 'tagbar',
      \ 'todoist',
      \ 'tsplayground',
      \ 'vista',
      \ 'vista_kind',
      \ 'vista_markdown',
      \ ]
let mkdp_filetypes = ['markdown', 'vimwiki']
let neoinclude#max_processes = py3eval('os.cpu_count()')
let todoist = #{
      \   icons: #{
      \     unchecked: '  ',
      \     checked: '  ',
      \     loading: '  ',
      \     error: '  ',
      \   },
      \ }
let WebDevIconsOS = 'Fedora'
let abolish_save_file = stdpath('config').'/after/plugin/abolish.vim'

lua require('user.config')
lua require('colorbuddy').colorscheme('user_colors')

" Airline: Bottom bar for Vim. {{{2

" Main settings
let airline_powerline_fonts  = v:true " Airline + Powerline
let airline_detect_spelllang = v:false " Cleans up stuff a little
let airline_detect_crypt     = v:false " Unavailable in neovim
" let airline_inactive_collapse = 1
let airline_skip_empty_sections = 1

let airline_symbols = get(g:, 'airline_symbols', {})
let airline_symbols['dirty'] = ' ' " Show an icon that's at least sorta correct

let airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

let airline#extensions#tabline#enabled = 1

let airline_filetype_overrides = #{
      \ LuaTree: ['LuaTree', ''],
      \ minimap: ['Map', ''],
      \ todoist: ['Todoist', ''],
      \ tsplayground: ['Tree-Sitter Playground', ''],
      \ vista: ['Vista', ''],
      \ vista_kind: ['Vista', ''],
      \ vista_markdown: ['Vista', ''],
      \ }

" ALE: Async linter {{{2
let ale_fix_on_save = v:true
let ale_disable_lsp = v:true

" This is mostly to disable linters which are better handled by another
" extension (I.E. Language servers, stuff covered by diagnostic-ls & efm).
let ale_linters_ignore = #{
      \ asciidoc:   ['alex', 'languagetool', 'writegood'],
      \ bats:       ['shellcheck'],
      \ c:          ['cc', 'clangtidy', 'cpplint'],
      \ cmake:      ['cmakelint'],
      \ cpp:        ['cc', 'clangtidy', 'cpplint'],
      \ css:        ['stylelint'],
      \ dockerfile: ['hadolint'],
      \ elixir:     ['credo'],
      \ eruby:      ['erb'],
      \ fish:       ['fish'],
      \ gitcommit:  ['gitlint'],
      \ graphql:    ['eslint'],
      \ help:       ['alex', 'writegood'],
      \ html:       ['tidy', 'writegood'],
      \ javascript: ['eslint', 'jshint', 'flow', 'standard', 'xo'],
      \ json:       ['jsonlint'],
      \ jsonc:      ['jsonlint'],
      \ less:       ['stylelint'],
      \ lua:        ['luacheck'],
      \ mail:       ['alex', 'languagetool'],
      \ markdown:   ['languagetool', 'markdownlint', 'writegood'],
      \ nroff:      ['alex', 'writegood'],
      \ objc:       ['clang'],
      \ objcpp:     ['clang'],
      \ php:        ['phpcs', 'phpstan'],
      \ po:         ['alex', 'writegood'],
      \ pod:        ['alex', 'writegood'],
      \ python:     ['flake8', 'mypy', 'pylint'],
      \ rst:        ['alex', 'rstcheck', 'writegood'],
      \ rust:       ['cargo'],
      \ sass:       ['stylelint'],
      \ scss:       ['stylelint'],
      \ sh:         ['shellcheck'],
      \ stylus:     ['stylelint'],
      \ sugarss:    ['stylelint'],
      \ teal:       ['tlcheck'],
      \ tex:        ['alex', 'writegood'],
      \ texinfo:    ['alex', 'writegood'],
      \ typescript: ['eslint', 'standard', 'tslint', 'xo'],
      \ vim:        ['vint'],
      \ vimwiki:    ['alex', 'languagetool', 'markdownlint', 'writegood'],
      \ vue:        ['eslint'],
      \ xhtml:      ['alex', 'writegood'],
      \ xsd:        ['xmllint'],
      \ xml:        ['xmllint'],
      \ xslt:       ['xmllint'],
      \ yaml:       ['yamllint'],
      \ zsh:        ['shell'],
      \ }

" Aliases
call extend(ale_linters_ignore, #{
      \ Dockerfile: ale_linters_ignore['dockerfile'],
      \ plaintex: ale_linters_ignore['tex'],
      \ })

let ale_fixers = #{
      \ cpp: ['clangtidy', 'remove_trailing_lines', 'trim_whitespace'],
      \ go: [
      \   'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace',
      \ ],
      \ html: ['tidy', 'remove_trailing_lines', 'trim_whitespace'],
      \ python: [
      \   'add_blank_lines_for_python_control_statements',
      \   'reorder-python-imports',
      \   'remove_trailing_lines',
      \   'trim_whitespace',
      \ ],
      \ rust: ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \ sql: ['sql-format', 'remove_trailing_lines', 'trim_whitespace'],
      \ xml: ['xmllint'],
      \ }
let ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
" sh - shfmt moved to diagnostic-ls
" less, scss - prettier moved to coc

let ale_linter_aliases = #{ jsonc: 'json' }

" Fedora exports autopep8 as autopep8-3 but that might be erroneous
if executable('autopep8-3') && !executable('autopep8')
  let ale_python_autopep8_executable = 'autopep8-3'
endif

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
let vimwiki_folding = 'expr'
let vimwiki_listsyms = '✗○◐●✓'

" Vista: replacement for tagbar {{{2
let vista#renderer#enable_icon = 1
let vista_echo_cursor_strategy = 'floating_win' " Floating vista window is super clean
let vista_executive_for = #{
      \ apiblueprint: 'markdown',
      \ c: 'coc',
      \ cpp: 'coc',
      \ cuda: 'coc',
      \ css: 'coc',
      \ go: 'coc',
      \ html: 'coc',
      \ javascript: 'coc',
      \ json: 'coc',
      \ jsonc: 'coc',
      \ lua: 'coc',
      \ markdown: 'toc',
      \ objc: 'coc',
      \ objcpp: 'coc',
      \ pandoc: 'markdown',
      \ python: 'coc',
      \ rst: 'toc',
      \ tex: 'coc',
      \ typescript: 'coc',
      \ vala: 'coc',
      \ vim: 'coc',
      \ vimwiki: 'markdown',
      \ xml: 'coc',
      \ yaml: 'coc',
      \ }
let vista_ctags_cmd = get(g:, 'vista_ctags_cmd', {}) " This isn't set by default

" Filetype Settings {{{1
" Python
let no_python_maps = v:true " All maps covered by nvim-treesitter

" Ruby
" TODO replace maps (there are a lot)
"   This is currently held up by tree-sitter textobjects not supporting ruby
" let no_ruby_maps = v:true

" SQL
let omni_sql_no_default_maps = v:true

" Tex
let tex_flavor = 'latex'

" VimL
let vimsyn_embed = 'lPr' " Embed lua, python, and ruby in vim syntax.
" TODO replace maps?
"   We'll need a tree-sitter parser or a language server to assist in
"   replacing maps, which may take a while. A language server is available,
"   but I don't know how to replace some of the maps; A tree-sitter parser may
"   never be developed due to how complex VimL is.
" let no_vim_maps = v:true

" Keybindings {{{1

inor <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inor <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnor <silent> <leader>h :call CocActionAsync('doHover')<cr>

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(EasyAlign)

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
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)

" map the Terminal function in the lua module to some shortcuts
nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

" Init augroup {{{1
aug init
  au!
  au FileType list setl nospell
  au FileType gitmessengerpopup setl winblend=10
  " Update signature help on jump placeholder
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Clean up Coc floating windows
  au User CocOpenFloat call setwinvar(g:coc_last_float_win, '&spell', 0)
  au User CocOpenFloat call setwinvar(g:coc_last_float_win, '&winblend', 10)
  au CompleteDone * if pumvisible() == 0 | pclose | endif
  au VimEnter * ++once call dein#call_hook('post_source')
  au BufEnter * if (winnr('$') == 1 && &filetype =~# '\%(vista\|tsplayground\)') | quit | endif
aug END
" vim:ft=vim fenc=utf-8 fdm=marker
