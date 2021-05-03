local findfile = require('vlib.fn').findfile

local clang_format = function()
  return {
    exe = 'clang-format',
    args = {'--assume-filename', vim.api.nvim_buf_get_name(0)},
    stdin = true,
  }
end

local prettier = function()
  return {exe = 'prettier', args = {'--stdin-filepath', vim.api.nvim_buf_get_name(0)}, stdin = true}
end

-- Note: some arguments have to be quoted now.
-- #38 makes it so that command arguments are joined before calling stuff

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
        return {exe = 'stylua', args = {'--config-path', stylua, '-'}, stdin = true}
      end
      return {exe = 'lua-format', stdin = true}
    end,
  },
  markdown = {prettier},
  rust = {function() return {exe = 'rustfmt', args = {'--emit', 'stdout'}, stdin = true} end},
  scss = {prettier},
  toml = {function() return {exe = 'taplo', args = {'format', '-'}, stdin = true} end},
  typescript = {prettier},
  xml = {function() return {exe = 'xmllint', args = {'--format', '-'}, stdin = true} end},
  yaml = {prettier},
}

-- Add fallback filetype
filetypes = setmetatable(filetypes, {__index = function(t) return t.___ end})

require('formatter').setup {logging = false, filetype = filetypes}

vim.cmd [[autocmd init BufWritePost * FormatWrite]]
