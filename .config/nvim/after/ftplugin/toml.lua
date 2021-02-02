if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', [[<cmd>call CocActionAsync('doHover')<cr>]], buffer = true, silent = true }
end
