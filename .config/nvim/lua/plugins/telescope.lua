---@type table<string, string>
local E = vim.env
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

local remap = vim.api.nvim_set_keymap
local opts = {silent = true, noremap = true}

remap('n', '<Leader>ff', [[<Cmd>Telescope find_files<CR>]], opts)
remap('n', '<Leader>fg', [[<Cmd>Telescope live_grep<CR>]], opts)
remap('n', '<Leader>fb', [[<Cmd>Telescope buffers<CR>]], opts)
remap('n', '<Leader>fh', [[<Cmd>Telescope help_tags<CR>]], opts)
remap('n', '<Leader><Leader>', [[<Cmd>Telescope frequency<CR>]], opts)
