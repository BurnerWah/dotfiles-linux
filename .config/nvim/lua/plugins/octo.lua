vim.g.loaded_octo = true

-- async loader for octo
local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  require("octo").setup()
  require("telescope").load_extension("octo")
  async:close()
end))
async:send()
