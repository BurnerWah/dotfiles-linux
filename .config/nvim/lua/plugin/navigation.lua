-- from https://gabrielpoca.com/2019-11-02-a-little-bit-of-lua-in-your-vim/

-- to save terminals
list_of_terms = {}

function Terminal(nr, ...)
  -- if the terminal with nr exists, set the current buffer to it
  if list_of_terms[nr] then
    -- change to the terminal
    vim.api.nvim_set_current_buf(list_of_terms[nr])
  -- if the terminal doesn't exist
  else
    -- create a buffer that's is unlisted and not a scratch buffer
    local buf = vim.api.nvim_create_buf(false, false)
    -- change to that buffer
    vim.api.nvim_set_current_buf(buf)
    -- create a terinal in the new buffer using my favorite shell
    vim.api.nvim_call_function('termopen', {'fish'})
    -- save a reference to that buffer
    list_of_terms[nr] = buf
  end
  vim.api.nvim_command(':setlocal nospell')
  -- change to insert mode
  vim.api.nvim_command(':startinsert')
end

-- Map the Terminal function in the lua module to some shortcuts
vim.keymap.nnoremap { '<leader>kh', [[<cmd>lua Terminal(1)<cr>]], silent = true }
vim.keymap.nnoremap { '<leader>kj', [[<cmd>lua Terminal(2)<cr>]], silent = true }
vim.keymap.nnoremap { '<leader>kk', [[<cmd>lua Terminal(3)<cr>]], silent = true }
vim.keymap.nnoremap { '<leader>kl', [[<cmd>lua Terminal(4)<cr>]], silent = true }
