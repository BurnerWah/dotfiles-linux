vim.wo.spell = true
vim.wo.foldlevel = 2

local inor = vim.keymap.inoremap

-- Resolve completion issues
if vim.fn['vimwiki#vars#get_global']('key_mappings').table_mappings then
  inor {'<Tab>', [[pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()]], buffer = true, expr = true}
  inor {
    '<S-Tab>',
    [[pumvisible() ? "\<C-p>" : vimwiki#tbl#kbd_shift_tab()]],
    buffer = true,
    expr = true,
  }
end

vim.cmd [[autocmd! user_ftplugin * <buffer>]]
