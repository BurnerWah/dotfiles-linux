local tablex = require('pl.tablex')

---@type table<string, string>
local E = vim.env

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  require('telescope').setup({
    defaults = {winblend = 10, file_sorter = require('telescope.sorters').get_fzy_sorter},
    extensions = {
      arecibo = {selected_engine = 'duckduckgo', show_domain_icons = true, show_http_headers = true},
      bookmarks = {selected_browser = 'firefox', url_open_command = 'xdg-open'},
      frecency = {
        show_scores = true,
        ignore_patterns = {'*.git/*', '*/tmp/*', E.XDG_CACHE_HOME or (E.HOME .. '/.cache')},
        workspaces = {
          conf = E.XDG_CONFIG_HOME or (E.HOME .. '/.config'),
          data = E.XDG_DATA_HOME or (E.HOME .. '/.local/share'),
          project = E.HOME .. '/Projects',
        },
      },
      fzf_writer = {use_highlighter = true},
    },
  })
  tablex.foreach({
    'fzf', 'fzy_native', 'fzf_writer', 'gh', 'node_modules', 'media_files', 'sonictemplate',
    'bookmarks', 'frecency', 'cheat', 'arecibo', 'dap', 'githubcoauthors', 'npm',
  }, require('telescope').load_extension)

  vim.keymap.nmap {'<Leader>ff', '<Cmd>Telescope find_files<CR>', silent = true}
  vim.keymap.nmap {'<Leader>fg', '<Cmd>Telescope live_grep<CR>', silent = true}
  vim.keymap.nmap {'<Leader>fb', '<Cmd>Telescope buffers<CR>', silent = true}
  vim.keymap.nmap {'<Leader>fh', '<Cmd>Telescope help_tags<CR>', silent = true}
  vim.keymap.nmap {'<Leader>fF', '<Cmd>Telescope frequency<CR>', silent = true}

  async:close()
end))
async:send()
