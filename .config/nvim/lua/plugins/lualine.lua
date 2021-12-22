local codicons = vim.F.npcall(require, "codicons")

require("lualine").setup({
  options = {
    theme = "tokyonight",
    section_separators = { "", "" },
    component_separators = { "", "" },
  },
  sections = {
    lualine_b = (function()
      local section = {
        "branch",
        (vim.F.npcall(require, "github-notifications") or {}).statusline_notification_count,
        "diff",
        {
          "diagnostics",
          sources = { "nvim" },
          symbols = {
            error = codicons and (codicons.get("error") .. " ") or nil,
            warn = codicons and (codicons.get("warning") .. " ") or nil,
            info = codicons and (codicons.get("info") .. " ") or nil,
          },
        },
      }
      if not section[2] then
        table.remove(section, 2)
      end
      return section
    end)(),
    lualine_c = {
      "filename",
      "lsp_progress",
    },
  },
})
