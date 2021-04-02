require('lspsaga').init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  code_action_prompt = {virtual_text = false},
  finder_action_keys = {
    open = 'o',
    vsplit = 's',
    split = 'i',
    quit = {'q', '<Esc>'},
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
  },
  code_action_keys = {quit = {'q', '<Esc>'}, exec = '<CR>'},
  rename_action_keys = {quit = {'<C-c>', '<Esc>'}, exec = '<CR>'},
  border_style = 2, -- Rounded border
}
local nnor, tnor = vim.keymap.nnoremap, vim.keymap.tnoremap
nnor {'<A-d>', [[<Cmd>Lspsaga open_floaterm fish<CR>]], silent = true}
tnor {'<A-d>', [[<C-\><C-n><Cmd>Lspsaga close_floaterm<CR>]], silent = true}
