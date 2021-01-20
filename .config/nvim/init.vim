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
" Core settings
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

" Load python utilities
" exe printf('py3file %s/util.py', stdpath('config'))

lua require('plugins')
lua require('navigation')

let snips_author = 'Jaden Pleasants'
let snips_email  = 'jadenpleasants@fastmail.com'
let mkdp_filetypes = ['markdown', 'vimwiki']

" Filetype Settings
" Python
let no_python_maps = v:true " All maps covered by nvim-treesitter

" SQL
let omni_sql_no_default_maps = v:true

" Tex
let tex_flavor = 'latex'

" VimL
let vimsyn_embed = 'lPr' " Embed lua, python, and ruby in vim syntax.

" Keybindings

inor <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inor <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" nnor <silent> <leader>hh :call CocActionAsync('doHover')<cr>

" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" use normal command like `<leader>xi(`
" nmap <leader>x  <Plug>(coc-cursors-operator)

" map the Terminal function in the lua module to some shortcuts
nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

" Init augroup
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
  au BufEnter * if (winnr('$') == 1 && &filetype =~# '\%(vista\|tsplayground\)') | quit | endif
aug END
" vim:ft=vim fenc=utf-8 fdm=marker
