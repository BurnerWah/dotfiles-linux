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

return Terminal
