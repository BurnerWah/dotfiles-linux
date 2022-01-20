local gesture = require("gesture")

vim.keymap.set('n', "<RightMouse>", "<Nop>" {noremap=true,})
vim.keymap.set('n', "<RightDrag>", gesture.draw, {noremap=true,silent = true })
vim.keymap.set('n', "<RightRelease>", gesture.finish, {noremap=true,silent = true })

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  gesture.register({
    name = "scroll to bottom",
    inputs = { gesture.up(), gesture.down() },
    action = function()
      vim.api.nvim_feedkeys("G", "n", true)
    end,
  })

  async:close()
end))
async:send()
