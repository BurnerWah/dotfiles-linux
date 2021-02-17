vim.bo.tabstop = 2

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
end
