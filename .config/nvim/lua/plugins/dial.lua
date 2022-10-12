-- Configuration
local augend = require("dial.augend")
local config = require("dial.config")
config.augends:register_group({
  -- default augends used when no group name is specified
  default = {
    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
    augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
    augend.integer.alias.binary, -- binary values (0b01, etc.)
    augend.date.alias["%Y/%m/%d"], -- date (2022/08/06, etc.)
    augend.date.alias["%Y-%m-%d"], -- date (2022-08-06, etc.)
    augend.date.alias["%m/%d"], -- short date (08/06, etc.)
    augend.date.alias["%H:%M"], -- time (13:30, etc.)
    augend.constant.alias.bool, -- boolean value (true <-> false)
    augend.semver.alias.semver, -- semantiv versions (0.3.0, 1.2.8, etc.)
  },
})

-- Keymaps
local maps = require("dial.map")

vim.keymap.set("n", "<C-a>", maps.inc_normal(), { noremap = true })
vim.keymap.set("n", "<C-x>", maps.dec_normal(), { noremap = true })
vim.keymap.set("v", "<C-a>", maps.inc_visual(), { noremap = true })
vim.keymap.set("v", "<C-x>", maps.dec_visual(), { noremap = true })
vim.keymap.set("v", "g<C-a>", maps.inc_gvisual(), { noremap = true })
vim.keymap.set("v", "g<C-x>", maps.dec_gvisual(), { noremap = true })
