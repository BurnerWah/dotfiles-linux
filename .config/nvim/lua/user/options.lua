-- TODO convert vim.cmd calls to pure Lua
-- Imports & Functions {{{1
local V = require('vlib')
local exepath = V.fn.exepath
local has = V.fn.has
local executable = V.fn.executable

-- Global options {{{1

-- Vim settings

vim.api.nvim_exec([[
  set expandtab     " Use spaces instead of tabs.
  set softtabstop=2 " Tab key indents by 2 spaces
  set shiftwidth=2  " >> indents by 2 spaces
]], false)
vim.o.shiftround = true -- >> indents to next multiple of 'shiftwidth'.
vim.cmd [[set smartindent]]
vim.o.hidden = true --  Switch between buffers without having to save first.
vim.o.lazyredraw = true -- Only redraw when necessary
vim.o.splitbelow = true -- Open new windows below the current window.
vim.o.splitright = true -- Open new windows right of the current window.
vim.cmd [[set cursorline]] -- Find the current line quickly
vim.o.report = 0 -- Always report changed lines.
vim.cmd [[set synmaxcol=250]] -- Only highlight the first 250 collumns
vim.o.mouse = 'a' -- Mouse support
vim.o.termguicolors = true -- Truecolor mode

vim.o.timeoutlen = 500

vim.o.titlestring = 'nvim %t'
vim.o.titleold = '%{fnamemodify(getcwd(), ":t")}'
vim.o.title = true

-- Grep program
-- We want to use ripgrep because it's the fastest.
-- Nothing else really compares to it, so the next best option is assuming grep is symlinked to ugrep.
if executable('rg') then
  vim.o.grepprg = [[rg -SL --hidden -g !.git --no-heading --vimgrep $*]]
  vim.o.grepformat = '%f:%l:%c:%m,' .. vim.o.grepformat
end

-- Enable spell checking
--
-- This has to be disabled due to a conflict with nvim-treesitter (issue #698).
-- Instead, enable it on filetypes which tree-sitter doesn't support.
--
-- TODO rewrite settings in Lua
vim.api.nvim_exec([[
  set nospell
  set spelllang=en_us
]], false)

vim.o.pumblend = 10 -- Slightly transparent menus
vim.o.sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages,winpos,winsize'
vim.o.updatetime = 300

-- Show non-printable characters
vim.cmd [[set list]]
if has('multi_byte') then
  vim.o.listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:-'
else
  vim.o.listchars = 'tab:> ,extends:>,precedes:<,nbsp:+,trail:-'
end

if has('conceal') then
  vim.api.nvim_exec([[
    set conceallevel=2
    set concealcursor=nv
  ]], false)
end

-- Fish causes problems with plugins
-- vim.o.shell = vim.o.shell:find('fish$') and 'bash' or vim.o.shell

-- Environment {{{1
-- nvr support
if executable('nvr') then
  vim.env.EDITOR = 'nvr -cc split --remote-wait'
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end

-- Global variables (pseudo-options) {{{1

V.dsl.let {
  loaded_python_provider = 0, -- Block Python 2 rplugins
  loaded_perl_provider = 0, -- Block Perl rplugins
  node_host_prog = exepath('neovim-node-host'),
  ruby_host_prog = exepath('neovim-ruby-host'),
  netrw_nogx = true,
  astronauta_load_keymap = false, -- We do this early
  loaded_fzf = false, -- No pls don't load this I don't use it at all

  -- Filetype settings

  no_python_maps = true, -- All maps covered by nvim-treesitter
  omni_sql_no_default_maps = true,
  tex_flavor = 'latex',
  vimsyn_embed = 'lPr', -- Embed Lua, Python, and Ruby in vim syntax

  -- Other
  -- (this should go elsewhere but there isn't a good place for it)

  snips_author = 'Jaden Pleasants',
  snips_email = 'jadenpleasants@fastmail.com',
}

-- vim:ft=lua fdm=marker
