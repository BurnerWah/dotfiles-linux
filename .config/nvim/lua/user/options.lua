-- TODO convert vim.cmd calls to pure Lua
-- Imports & Functions {{{1
local exepath = vim.fn.exepath
local has = vim.fn.has

-- Global options {{{1

-- Vim settings

vim.cmd [[set expandtab]] -- Use spaces instead of tabs.
vim.cmd [[set softtabstop=2]] -- Tab key indents by 2 spaces
vim.cmd [[set shiftwidth=2]] -- >> indents by 2 spaces
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

--[[
  Enable spell checking

  This has to be disabled due to a conflict with nvim-treesitter (issue #698).
  Instead, enable it on filetypes which tree-sitter doesn't support.

  TODO rewrite settings in Lua
  ]]
vim.cmd [[set nospell]]
vim.cmd [[set spelllang=en_us]]

vim.o.pumblend = 10 -- Slightly transparent menus
vim.o.sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages,winpos,winsize'
vim.o.updatetime = 300

-- Show non-printable characters
vim.cmd [[set list]]
-- This is inelegant but it works well enough.
vim.o.listchars = (((has('multi_byte') == 1) and vim.o.encoding == 'utf-8') and
                      [[tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:-]] or
                      [[tab:> ,extends:>,precedes:<,nbsp:+,trail:-]])

if (has('conceal') == 1) then
  vim.cmd [[set conceallevel=2]]
  vim.cmd [[set concealcursor=nv]]
end

-- Fish causes problems with plugins
vim.o.shell = ((vim.o.shell:find('fish$')) and 'bash' or vim.o.shell)

-- Environment {{{1
-- nvr support
if (vim.fn.executable('nvr') == 1) then
  vim.env.EDITOR = 'nvr -cc split --remote-wait'
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end

-- Global variables (pseudo-options) {{{1

vim.g.loaded_python_provider = 0 -- Block Python 2 rplugins
vim.g.loaded_perl_provider = 0 -- Block Perl rplugins
vim.g.node_host_prog = exepath('neovim-node-host')
vim.g.ruby_host_prog = exepath('neovim-ruby-host')
vim.g.netrw_nogx = true

-- Filetype settings {{{1

-- Python
vim.g.no_python_maps = true -- All maps covered by nvim-treesitter

-- SQL
vim.g.omni_sql_no_default_maps = true

-- Tex
vim.g.tex_flavor = 'latex'

-- VimL
vim.g.vimsyn_embed = 'lPr' -- Embed Lua, Python, and Ruby in vim syntax.

-- Other {{{1
-- (this should go elsewhere but there isn't a good place for it)
vim.g.snips_author = 'Jaden Pleasants'
vim.g.snips_email = 'jadenpleasants@fastmail.com'
vim.g.auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions'

-- vim:ft=lua fdm=marker
