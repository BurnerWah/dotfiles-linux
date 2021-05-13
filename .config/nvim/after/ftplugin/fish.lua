local has_plenary_path, Path = pcall(require, 'plenary.path')
local has_pnelary_fun, F = pcall(require, 'plenary.functional')

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.comments = ':#'
vim.bo.commentstring = '#%s'

vim.bo.define = [[\v^\s*function>]]
vim.bo.include = [[\v^\s*\.>]]
vim.bo.suffixesadd = '.fish'

if has_plenary_path and has_pnelary_fun then
  vim.bo.path = F.join({
    Path:new(vim.env.XDG_CONFIG_HOME or '~/.config', 'fish', 'functions'):expand(),
    '/etc/fish/functions',
    unpack(vim.tbl_map(function(dir) return Path:new(dir, 'fish', 'vendor_functions.d') end,
                       vim.split(vim.env.XDG_DATA_DIRS or '/usr/local/share:/usr/share', ':'))),
  }, ',')
end
---@diagnostic disable-next-line: undefined-field
vim.b.match_words = vim.fn.escape(table.concat({
  [[<%(begin|function|%(else\s+)\@<!if|switch|while|for)>]], [[<else\s\+if|case>]], [[<else>]],
  [[<end>]],
}, ':'), '+<>%|)')

vim.b.endwise_addition = 'end'
vim.b.endwise_words = 'begin,function,if,switch,while,for'

vim.bo.shiftwidth = 4
