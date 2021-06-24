vim.bo.comments, vim.bo.commentstring = ':#', '# %s'
vim.opt_local.formatoptions:remove('f'):append('crol')
vim.bo.textwidth = ((vim.o.textwidth == 0) and 80 or vim.bo.textwidth)
