local codicons = require('codicons')
vim.g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1}
vim.g.nvim_tree_icons = {
  symlink = codicons.get('file-symlink-file'),
  git_icons = {
    renamed = codicons.get('diff-renamed'),
    deleted = codicons.get('diff-removed'),
    ignored = codicons.get('diff-ignored'),
  },
  folder = {
    default = codicons.get('folder'),
    open = codicons.get('folder-opened'),
    symlink = codicons.get('file-symlink-directory'),
  },
  lsp = {
    hint = codicons.get('question'),
    info = codicons.get('info'),
    warning = codicons.get('warning'),
    error = codicons.get('error'),
  },
}
vim.defer_fn(require('nvim-tree').refresh, 50)
