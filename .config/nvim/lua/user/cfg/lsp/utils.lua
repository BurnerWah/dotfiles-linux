local M = {}

local Path = require('plenary.path')
local lsp_util = require('lspconfig/util')

local ts_root_finders = {
  node = function(fname)
    return lsp_util.root_pattern('tsconfig.json')(fname) or
               lsp_util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
  end,
  deno = lsp_util.root_pattern('package.json', 'tsconfig.json', '.git'),
}

---Determine whether to use TSServer or Deno LSP, and provide a root dir
---to nvim-lspconfig.
---@param ts? "node"|"deno" TS Server to find a root for. Defaults to node.
---@return function a function to use as a root_dir for nvim-lspconfig.
function M.tsdetect(ts)
  ts = ts or 'node'
  return function(fname)
    local detected, root = nil, nil
    local p = Path:new(fname)
    -- Attempt to use shebang
    if p:is_file() then
      local head = p:head(1)
      if head:sub(1, 2) == '#!' then
        if head:find('node') then
          detected = 'node'
        elseif head:find('deno') then
          detected = 'deno'
        end
      end
    end
    -- TODO: Add way to ensure that dirs for a file have the same server (for :LspInfo)
    -- Look for a node_modules folder
    if not detected then
      local node_modules = lsp_util.find_node_modules_ancestor(fname)
      if node_modules then detected = 'node' end
    end
    -- TODO: add more heuristics
    -- fall back to node
    detected = detected or 'node'
    -- Break out if we detected a different ts
    if detected ~= ts then return end
    -- Finally, actually detect the root dir
    if not root then
      local root_finder = ts_root_finders[detected]
      root = root_finder(fname)
    end
    return root
  end
end

return M
