local M = {}

-- Custom initializer for nvim-cursorline
function M.config()
  vim.g.loaded_cursorword = 1
  vim.cmd [[highlight default CursorWord term=underline cterm=underline gui=underline]]
end

function M.on_attach()
  vim.api.nvim_exec([[
    augroup user.cursorline
      autocmd! * <buffer>
      autocmd! CursorMoved,CursorMovedI <buffer> call luaeval("require'nvim-cursorline'.cursor_moved()")
      autocmd! WinEnter <buffer> call luaeval("require'nvim-cursorline'.win_enter()")
      autocmd! WinLeave <buffer> call luaeval("require'nvim-cursorline'.win_leave()")
    augroup END
  ]], false)
end
M.ftplugin = M.on_attach

return M
