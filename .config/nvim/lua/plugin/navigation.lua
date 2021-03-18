-- heavily adapted from https://gabrielpoca.com/2019-11-02-a-little-bit-of-lua-in-your-vim/
local Terminal = class(Map)

function Terminal:switch(nr)
  if self:get(nr) then
    vim.api.nvim_set_current_buf(self:get(nr))
  else
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_set_current_buf(buf)
    vim.fn.termopen('fish')
    self:set(nr, buf)
  end
  vim.wo.spell = false
  vim.cmd [[startinsert]]
end

function Terminal:mapper(nr) return function() self:switch(nr) end end

local t = Terminal()
vim.keymap.nnoremap {'<Leader>kh', t:mapper(1), silent = true}
vim.keymap.nnoremap {'<Leader>kj', t:mapper(2), silent = true}
vim.keymap.nnoremap {'<Leader>kk', t:mapper(3), silent = true}
vim.keymap.nnoremap {'<Leader>kl', t:mapper(4), silent = true}
