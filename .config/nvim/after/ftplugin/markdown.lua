-- Try to disable stuff we don't want on for :checkhealth
if vim.wo.breakindent and vim.wo.linebreak then
  vim.wo.foldlevel = 99
  vim.wo.listchars = (vim.fn.has('multi_byte') == 1 and
                         [[tab:▸ ,extends:❯,precedes:❮,nbsp:±]] or
                         [[tab:> ,extends:>,precedes:<,nbsp:+]])
  -- Clear unwanted commands
  vim.api.nvim_exec([[
    sil! delc Toc
    sil! delc Toch
    sil! delc Tocv
    sil! delc Toct
    sil! delc InsertToc
    sil! delc InsertNToc
    sil! delc SetexToAtx
    sil! delc TableFormat
    sil! delc HeaderDecrease
    sil! delc HeaderIncrease
    sil! delc MarkdownPreview
  ]], false)
end
