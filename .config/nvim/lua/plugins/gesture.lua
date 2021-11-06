local gesture = require("gesture")

vim.keymap.nnoremap({ "<RightMouse>", "<Nop>" })
vim.keymap.nnoremap({ "<RightDrag>", gesture.draw, silent = true })
vim.keymap.nnoremap({ "<RightRelease>", gesture.finish, silent = true })

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
