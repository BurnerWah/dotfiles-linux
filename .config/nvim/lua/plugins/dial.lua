local dial = require('dial')
local nnor, vmap = vim.keymap.nnoremap, vim.keymap.vmap

-- Boolean flipping
dial.augends['custom#boolean'] = dial.common.enum_cyclic {
  name = 'boolean',
  desc = 'Flip a boolean between true and false',
  strlist = {'true', 'false'},
}
table.insert(dial.config.searchlist.normal, 'custom#boolean')

-- Keymaps - We add repeat support to this
nnor {
  '<C-a>', function()
    dial.cmd.increment_normal(vim.v.count1)
    pcall(vim.cmd, [[silent! call repeat#set("\<C-a>", v:count)]])
  end,
}
nnor {
  '<C-x>', function()
    dial.cmd.increment_normal(-vim.v.count1)
    pcall(vim.cmd, [[silent! call repeat#set("\<C-x>", v:count)]])
  end,
}
-- vim.keymap.nmap {'<C-a>', '<Plug>(dial-increment)'}
-- vim.keymap.nmap {'<C-x>', '<Plug>(dial-decrement)'}
vmap {'<C-a>', '<Plug>(dial-increment)'}
vmap {'<C-x>', '<Plug>(dial-decrement)'}
vmap {'g<C-a>', '<Plug>(dial-increment-additional)'}
vmap {'g<C-x>', '<Plug>(dial-decrement-additional)'}
