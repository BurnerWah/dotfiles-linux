vim.bo.comments, vim.bo.commentstring = ':#', '# %s'
vim.cmd [[setlocal fo-=t fo+=crol]]
vim.bo.textwidth = ( (vim.o.textwidth == 0) and 80 or vim.bo.textwidth )
