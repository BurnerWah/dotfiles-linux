local feedkeys, replace_termcodes = vim.api.nvim_feedkeys, vim.api.nvim_replace_termcodes
-- local hlslens = require('hlslens')
-- This will let us delete the search end keymap when we're done with it
vim.keymap.set("n", "<Plug>(UserEndHlslens)", function()
  feedkeys(replace_termcodes(":nohlsearch<CR>", true, false, true), "n", true)
  vim.cmd("nunmap <Leader>l")
end, { noremap = true, silent = true })

local mapgen = {
  iterate = function(key)
    return function()
      -- This used to use vim.cmd, but that broke. Feedkeys works better anyway though.
      feedkeys(vim.v.count1 .. key, "n", true)
      require("hlslens").start()
      vim.keymap.set("n", "<Leader>l", "<Plug>(UserEndHlslens)", { silent = true })
    end
  end,
  search = function(key)
    return function()
      feedkeys(key, "n", true)
      require("hlslens").start()
      vim.keymap.set("n", "<Leader>l", "<Plug>(UserEndHlslens)", { silent = true })
    end
  end,
}

vim.keymap.set("n", "n", mapgen.iterate("n"), { noremap = true, silent = true })
vim.keymap.set("n", "N", mapgen.iterate("N"), { noremap = true, silent = true })

vim.keymap.set("n", "*", mapgen.search("*"), { noremap = true })
vim.keymap.set("n", "#", mapgen.search("#"), { noremap = true })
vim.keymap.set("n", "g*", mapgen.search("g*"), { noremap = true })
vim.keymap.set("n", "g#", mapgen.search("g#"), { noremap = true })

require("hlslens").setup({
  auto_enable = true,
  nearest_float_when = "auto",
  override_lens = function(render, plist, nearest, idx, r_idx)
    local sfw = vim.v.searchforward == 1
    local indicator, text, chunks
    local abs_r_idx = math.abs(r_idx)
    if abs_r_idx > 1 then
      indicator = string.format("%d%s", abs_r_idx, sfw ~= (r_idx > 1) and "▲" or "▼")
    elseif abs_r_idx == 1 then
      indicator = sfw ~= (r_idx == 1) and "▲" or "▼"
    else
      indicator = ""
    end

    local lnum, col = unpack(plist[idx])
    if nearest then
      local cnt = #plist
      if indicator ~= "" then
        text = string.format("[%s %d/%d]", indicator, idx, cnt)
      else
        text = string.format("[%d/%d]", idx, cnt)
      end
      chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
    else
      text = string.format("[%s %d]", indicator, idx)
      chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
    end
    render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
  end,
})
-- hlslens.enable()
