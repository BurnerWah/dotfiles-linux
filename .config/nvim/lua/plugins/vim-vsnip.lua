return function()
  vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'
  local imap, smap = vim.keymap.imap, vim.keymap.smap
  -- Expand
  imap {'<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], expr = true}
  smap {'<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], expr = true}
  -- Expand or jump
  imap {'<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], expr = true}
  smap {'<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], expr = true}
end
