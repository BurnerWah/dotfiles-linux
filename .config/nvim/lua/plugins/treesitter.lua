local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    -- ignore_install = { "kotlin", "verilog" }, -- These parsers are really big
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true }, -- Indent uses 'tabstop' so it has to be managed in ftplugins.
    playground = { enable = true },
    refactor = { highlight_definitions = { enable = true }, smart_rename = { enable = true } },
    textobjects = {
      select = {
        enable = true,
      },
      -- move = {
      --   enable = true,
      --   goto_next_start = { ["]m"] = text_objects.fn.outer, ["]]"] = text_objects.class.outer },
      --   goto_next_end = {
      --     ["]M"] = text_objects.fn.outer,
      --     ["]["] = text_objects.class.outer,
      --     ["]*"] = text_objects.comment.outer,
      --     ["]/"] = text_objects.comment.outer,
      --   },
      --   goto_previous_start = {
      --     ["[m"] = text_objects.fn.outer,
      --     ["[["] = text_objects.class.outer,
      --     ["[*"] = text_objects.comment.outer,
      --     ["[/"] = text_objects.comment.outer,
      --   },
      --   goto_previous_end = { ["[M"] = text_objects.fn.outer, ["[]"] = text_objects.class.outer },
      -- },
      -- swap = {
      --   enable = true,
      --   swap_next = { ["<Leader>a"] = '@parameter.inner' },
      --   swap_previous = { ["<Leader>A"] = '@parameter.inner' },
      -- },
    },
    textsubjects = {
      enable = true,
      keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
    },
    autotag = { enable = true },
    context_commentstring = { enable = true },
    autopairs = { enable = true },
    -- tree_docs = { enable = true },
  })

  local parsers = require("nvim-treesitter.parsers").get_parser_configs()
  parsers.just = parsers.just
    or {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
      },
      filetype = "just",
      maintainers = { "@IndianBoy42" },
    }
  -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  -- parser_config.bash.used_by = { "PKGBUILD" }

  async:close()
end))

async:send()
