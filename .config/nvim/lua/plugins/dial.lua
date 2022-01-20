local dial = require("dial")

-- Boolean flipping
dial.augends["custom#boolean"] = dial.common.enum_cyclic({
  name = "boolean",
  desc = "Flip a boolean between true and false",
  strlist = { "true", "false" },
})
table.insert(dial.config.searchlist.normal, "custom#boolean")

-- Keymaps - We add repeat support to this
vim.keymap.set("n", "<C-a>", function()
  dial.cmd.increment_normal(vim.v.count1)
  pcall(vim.cmd, [[silent! call repeat#set("\<C-a>", v:count)]])
end, { noremap = true })
vim.keymap.set("n", "<C-x>", function()
  dial.cmd.increment_normal(-vim.v.count1)
  pcall(vim.cmd, [[silent! call repeat#set("\<C-x>", v:count)]])
end, { noremap = true })
vim.keymap.set("v", "<C-a>", "<Plug>(dial-increment)")
vim.keymap.set("v", "<C-x>", "<Plug>(dial-decrement)")
vim.keymap.set("v", "g<C-a>", "<Plug>(dial-increment-additional)")
vim.keymap.set("v", "g<C-x>", "<Plug>(dial-decrement-additional)")
