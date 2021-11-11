local M = {}

local uv = vim.loop
local Path = require("plenary.path")
local lsp_util = require('lspconfig/util')

---@type table<string, boolean>
local workspace_roots = {}

local registry = {
  ['package.json'] = {}
}

function M.process_dir(dir)
  if workspace_roots[dir] then
    return
  end
  local path = Path:new(dir)
  local parents = path:parents()
  for _, parent in ipairs(parents) do
    if workspace_roots[parent] then
      return
    end
  end

  local handler
  handler = uv.new_async(function()
    local root
    if path:joinpath(".git"):is_dir() then
      root = path:absolute()
      workspace_roots[root] = true
    else
      for _, parent in ipairs(parents) do
        if not root and Path:new({parent, '.git'}):is_dir() then
          root = parent
          workspace_roots[parent] = true
        end
      end
    end

    if root then
      
    end
    handler:close()
  end)
  handler:send()
end

return M
