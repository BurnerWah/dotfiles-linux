vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
  vim.cmd [[autocmd user_ftplugin CursorHold <buffer> silent call CocActionAsync('highlight')]]
end

if (packer_plugins['lspsaga.nvim'] and packer_plugins['lspsaga.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', require('lspsaga.hover').render_hover_doc, buffer = true, silent = true }
end
