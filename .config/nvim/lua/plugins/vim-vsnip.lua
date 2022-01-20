return function()
  vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/vsnip"
  -- Expand
  vim.keymap.set("i", "<C-j>", [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], { expr = true })
  vim.keymap.set("s", "<C-j>", [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], { expr = true })
  -- Expand or jump
  vim.keymap.set("i", "<C-l>", [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true })
  vim.keymap.set("s", "<C-l>", [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true })
end
