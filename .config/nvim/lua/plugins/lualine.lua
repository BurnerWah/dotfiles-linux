local codicons = vim.F.npcall(require, "codicons")

require("lualine").setup({
  options = {
    theme = "tokyonight",
    -- section_separators = { "", "" },
    -- component_separators = { "", "" },
  },
  sections = {
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = codicons and (codicons.get("error") .. " ") or nil,
          warn = codicons and (codicons.get("warning") .. " ") or nil,
          info = codicons and (codicons.get("info") .. " ") or nil,
        },
      },
    },
    lualine_c = {
      "filename",
      "lsp_progress",
    },
  },
})
