local codicons = require('codicons')
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
  sections = {
    lualine_c = {
      'filename', {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = {
          error = codicons.get('error') .. ' ',
          warn = codicons.get('warning') .. ' ',
          info = codicons.get('info') .. ' ',
        },
      }, 'lsp_progress',
    },
  },
})
