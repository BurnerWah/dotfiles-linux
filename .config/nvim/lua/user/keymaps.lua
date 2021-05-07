UserMaps = {}
local imap, smap = vim.keymap.imap, vim.keymap.smap
local vnor = vim.keymap.vnoremap
local pumvisible, getline = vim.fn.pumvisible, vim.fn.getline
local compe_complete = vim.fn['compe#complete']
local vsnip = {
  available = function(...) return vim.fn['vsnip#available'](...) == 1 end,
  jumpable = function(...) return vim.fn['vsnip#jumpable'](...) == 1 end,
}

-- Lazy require
local npairs = setmetatable({}, {
  __index = function(self, key)
    print('Replaced key')
    self[key] = require('nvim-autopairs')[key]
    return self[key]
  end,
})

local function replace_termcodes(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local function check_back_space()
  local col = vim.fn.col('.') - 1
  if (col == 0 or getline('.'):sub(col, col):match('%s')) then
    return true
  else
    return false
  end
end

function UserMaps.tab_complete()
  if (pumvisible() == 1) then return replace_termcodes('<C-n>') end
  if vsnip.available(1) then return replace_termcodes('<Plug>(vsnip-expand-or-jump)') end
  if check_back_space() then return replace_termcodes('<Tab>') end
  return compe_complete()
end

function UserMaps.s_tab_complete()
  if (pumvisible() == 1) then return replace_termcodes('<C-p>') end
  if vsnip.jumpable(-1) then return replace_termcodes('<Plug>(vsnip-jump-prev)') end
  return replace_termcodes('<S-Tab>')
end

function UserMaps.on_enter()
  if (pumvisible() ~= 0) then
    if vim.fn.complete_info().selected ~= -1 then
      return vim.fn['compe#confirm'](npairs.esc('<CR>'))
    else
      return npairs.esc('<CR>')
    end
  else
    return npairs.autopairs_cr()
  end
end

imap {'<Tab>', [[v:lua.UserMaps.tab_complete()]], expr = true}
smap {'<Tab>', [[v:lua.UserMaps.tab_complete()]], expr = true}
imap {'<S-Tab>', [[v:lua.UserMaps.s_tab_complete()]], expr = true}
smap {'<S-Tab>', [[v:lua.UserMaps.s_tab_complete()]], expr = true}
imap {'<CR>', [[v:lua.UserMaps.on_enter()]], expr = true}
vnor {'<', '<gv'}
vnor {'>', '>gv'}
