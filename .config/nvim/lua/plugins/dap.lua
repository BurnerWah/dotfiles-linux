local dap = require("dap")
local api = vim.api

local keymap_restore = {}

-- vim.g.dap_virtual_text = true

dap.adapters.cpp = {
  type = "executable",
  attach = { pidProperty = "pid", pidSelect = "ask" },
  command = "lldb-vscode",
  env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
  name = "lldb",
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      ---@diagnostic disable-next-line: undefined-field
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      ---@diagnostic disable-next-line: undefined-field
      local val = tonumber(vim.fn.input("Port: "))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end

--[[Map K to hover during sessions]]
dap.listeners.after.event_initialized.me = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, "n")
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, "n", "K")
      end
    end
  end
  api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.variables").hover()<CR>', { silent = true })
end

dap.listeners.after["event_terminated"]["me"] = function()
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
  end
  keymap_restore = {}
end

---@diagnostic disable-next-line: undefined-field
local sign_define = vim.fn.sign_define
local has_codicons, codicons = pcall(require, "codicons")
if has_codicons then
  sign_define("DapBreakpoint", { text = codicons.get("circle-filled"), texthl = "", linehl = "", numhl = "" })
  sign_define("DapLogPoint", { text = codicons.get("debug-breakpoint-log"), texthl = "", linehl = "", numhl = "" })
  sign_define("DapStopped", { text = codicons.get("debug-stop"), texthl = "", linehl = "", numhl = "" })
end

-- vim.keymap.set("n", "<F5>", [[<Cmd>lua require('dap').continue()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<F5>", dap.continue, { noremap = true, silent = true })
-- vim.keymap.set("n", "<F10>", [[<Cmd>lua require('dap').step_over()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<F10>", dap.step_over, { noremap = true, silent = true })
-- vim.keymap.set("n", "<F11>", [[<Cmd>lua require('dap').step_into()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<F11>", dap.step_into, { noremap = true, silent = true })
-- vim.keymap.set("n", "<F12>", [[<Cmd>lua require('dap').step_out()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<F12>", dap.step_out, { noremap = true, silent = true })
-- vim.keymap.set("n", "<Leader>b", [[<Cmd>lua require('dap').toggle_breakpoint()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<Leader>B",
  ---@diagnostic disable-next-line: undefined-field
  function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<Leader>lp",
  ---@diagnostic disable-next-line: undefined-field
  function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end,
  { noremap = true, silent = true }
)
-- vim.keymap.set("n", "<Leader>dr", [[<Cmd>lua require('dap').repl.open()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { noremap = true, silent = true })
-- vim.keymap.set("n", "<Leader>dl", [[<Cmd>lua require('dap').run_last()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>dl", dap.run_last, { noremap = true, silent = true })
