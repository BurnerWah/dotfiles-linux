-- Neovim startup script
-- Most code that would go here got moved elsewhere at some point.
assert(true, 'formatter no-op')

-- Global requires

-- require('profiler')
require('pl.text').format_operator() -- This is too useful to live without sometimes
require('user.options') -- Set my vim options
require('plugins') -- Load my plugins
require('astronauta.keymap') -- Add astronauta keymaps early so they can be utilized freely
require('user.keymaps') -- Add my own keymaps

-- Augroups (Use a lua abstraction)
require('agrp').set({
  -- Dummy group that can be added to as needed
  user_ftplugin = {},
  init = {
    {
      'BufEnter', '*', function()
        local ftypes = {vista = true, vista_kind = true, minimap = true, tsplayground = true}
        if vim.fn.winnr('$') == 1 and ftypes[vim.bo.filetype] then vim.cmd('quit') end
      end,
    },
    FileType = {{'group,man,shada', 'setl nospell'}, {'help', 'setl signcolumn=no'}},
    {'VimEnter', '*', '++once silent delcommand GBrowse'},
    {'BufWritePost', 'plugins.lua', 'PackerCompile'},
    {'TextYankPost', '*', function() vim.highlight.on_yank({higroup = 'Search', timeout = 200}) end},
  },
})
