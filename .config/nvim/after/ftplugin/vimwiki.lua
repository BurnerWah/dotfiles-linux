vim.wo.spell = true
vim.wo.foldlevel = 2

-- Resolve completion issues
if vim.fn["vimwiki#vars#get_global"]("key_mappings").table_mappings then
  vim.keymap.set(
    "i",
    "<Tab>",
    [[pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()]],
    { noremap = true, buffer = true, expr = true }
  )
  vim.keymap.set(
    "i",
    "<S-Tab>",
    [[pumvisible() ? "\<C-p>" : vimwiki#tbl#kbd_shift_tab()]],
    { noremap = true, buffer = true, expr = true }
  )
end

local has_codicons, codicons = pcall(require, "codicons")
vim.g.vimwiki_listsyms = table.concat({
  has_codicons and codicons.get("close") or "✗",
  has_codicons and codicons.get("circle-large-outline") or "○",
  has_codicons and codicons.get("color-mode") or "◐",
  has_codicons and codicons.get("circle-large-filled") or "●",
  has_codicons and codicons.get("check") or "✓",
})

vim.cmd([[autocmd! user_ftplugin * <buffer>]])
