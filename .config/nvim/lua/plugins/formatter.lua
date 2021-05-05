local findfile = require('vlib.fn').findfile
local shellescape = vim.fn.shellescape

local clang_format = function()
  return {
    exe = 'clang-format',
    args = {'--assume-filename', shellescape(vim.api.nvim_buf_get_name(0))},
    stdin = true,
  }
end

local prettier = function()
  return {
    exe = 'prettier',
    args = {'--stdin-filepath', shellescape(vim.api.nvim_buf_get_name(0))},
    stdin = true,
  }
end

-- Note: some arguments have to be quoted now.
-- #38 makes it so that command arguments are joined before calling stuff.
-- Apparently that's intended. I think that's fucking stupid, since everything
-- is exposed to the user as tables.
-- But since it's intended, fuck it, may as well just join things beforehand to
-- save time.

local filetypes = {
  -- Default meta-entry
  ___ = {
    function()
      return {exe = 'sed', args = {[[-e 's/[ \t]*$//' -e ':a; /^$/ { $d; N; ba; }']]}, stdin = true}
    end,
  },
  c = {clang_format},
  cpp = {clang_format},
  css = {prettier},
  fish = {function() return {exe = 'fish_indent', stdin = true} end},
  go = {
    function() return {exe = 'gofmt', stdin = true} end,
    function() return {exe = 'goimports', stdin = true} end,
  },
  html = {prettier},
  javascript = {prettier},
  json = {prettier},
  jsonc = {prettier},
  less = {prettier},
  lua = {
    function()
      -- Try to figure out what formatter should be used.
      local stylua = findfile('stylua.toml', '.;')
      if stylua then
        return {exe = 'stylua', args = {'--config-path', shellescape(stylua), '-'}, stdin = true}
      end
      return {exe = 'lua-format', stdin = true}
    end,
  },
  markdown = {prettier},
  python = {function() return {exe = 'black', args = {'-'}, stdin = true} end},
  rust = {function() return {exe = 'rustfmt', args = {'--emit stdout'}, stdin = true} end},
  scss = {prettier},
  toml = {function() return {exe = 'taplo', args = {'format -'}, stdin = true} end},
  typescript = {prettier},
  xml = {function() return {exe = 'xmllint', args = {'--format -'}, stdin = true} end},
  yaml = {prettier},
}

-- Add fallback filetype
filetypes = setmetatable(filetypes, {__index = function(t) return t.___ end})

require('formatter').setup {logging = false, filetype = filetypes}

vim.cmd [[autocmd init BufWritePost * FormatWrite]]
