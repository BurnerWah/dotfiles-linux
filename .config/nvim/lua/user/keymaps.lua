local M = {}
local imap, smap = vim.keymap.imap, vim.keymap.smap
local pumvisible, getline = vim.fn.pumvisible, vim.fn.getline
local compe_complete = vim.fn['compe#complete']
local vsnip = {
  available = function(...) return vim.fn['vsnip#available'](...) == 1 end,
  jumpable = function(...) return vim.fn['vsnip#jumpable'](...) == 1 end,
}

local function replace_termcodes(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local function check_back_space()
  local col = vim.fn.col('.') - 1
  if (col == 0 or getline('.'):sub(col, col):match('%s')) then
    return true
  else
    return false
  end
end

function M.tab_complete()
  if (pumvisible() == 1) then
    return replace_termcodes '<C-n>'
  elseif vsnip.available(1) then
    return replace_termcodes '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return replace_termcodes '<Tab>'
  else
    return compe_complete()
  end
end

function M.s_tab_complete()
  if (pumvisible() == 1) then
    return replace_termcodes '<C-p>'
  elseif vsnip.jumpable(-1) then
    return replace_termcodes '<Plug>(vsnip-jump-prev)'
  else
    return replace_termcodes '<S-Tab>'
  end
end

_G.UserMaps = M

imap {'<Tab>', [[v:lua.UserMaps.tab_complete()]], expr = true}
smap {'<Tab>', [[v:lua.UserMaps.tab_complete()]], expr = true}
imap {'<S-Tab>', [[v:lua.UserMaps.s_tab_complete()]], expr = true}
smap {'<S-Tab>', [[v:lua.UserMaps.s_tab_complete()]], expr = true}
