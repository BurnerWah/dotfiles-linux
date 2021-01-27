--[[
  Using an autocmd for this doesn't work correctly, since setttings can be overrided.
  As such, all configuration should be kept here instead.
  ]]

vim.bo.comments, vim.bo.commentstring = ':#', '# %s' -- Fix comments
