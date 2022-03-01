local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  local tablex = require("pl.tablex")
  local Set = require("pl.Set")

  ---@type table<string, string>
  local E = vim.env

  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      winblend = 10,
      file_sorter = require("telescope.sorters").get_fzy_sorter,
      history = { path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3", limit = 100 },
    },
    extensions = {
      arecibo = { selected_engine = "duckduckgo", show_domain_icons = true, show_http_headers = true },
      bookmarks = { selected_browser = "firefox", url_open_command = "xdg-open" },
      frecency = {
        show_scores = true,
        ignore_patterns = { "*.git/*", "*/tmp/*", E.XDG_CACHE_HOME or (E.HOME .. "/.cache") },
        workspaces = {
          conf = E.XDG_CONFIG_HOME or (E.HOME .. "/.config"),
          data = E.XDG_DATA_HOME or (E.HOME .. "/.local/share"),
          project = E.HOME .. "/Projects",
        },
      },
      fzf_writer = { use_highlighter = true },
      media_files = {
        filetypes = (function()
          local executable = require("vimstd.fn").executable
          local ret = Set({ "jpg", "png", "jpeg", "webp" })
          if executable("identify") then
            ret = ret + "gif"
          end
          if executable("ffmpegthumbnailer") then
            ret = ret + Set({ "mp4", "webm" })
          end
          if executable("pdftoppm") then
            ret = ret + Set({ "pdf", "epub" })
          end
          return Set.values(ret)
        end)(),
        find_cmd = "rg",
      },
    },
  })
  tablex.foreach({
    "fzf",
    "fzy_native",
    "fzf_writer",
    "gh",
    "media_files",
    "sonictemplate",
    "bookmarks",
    "frecency",
    "cheat",
    "arecibo",
    "dap",
    "githubcoauthors",
    "smart_history",
    "zoxide",
    "env",
  }, telescope.load_extension)

  vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>", { silent = true })
  vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope live_grep<CR>", { silent = true })
  vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>", { silent = true })
  vim.keymap.set("n", "<Leader>fh", "<Cmd>Telescope help_tags<CR>", { silent = true })
  vim.keymap.set("n", "<Leader>fF", "<Cmd>Telescope frequency<CR>", { silent = true })

  async:close()
end))
async:send()
