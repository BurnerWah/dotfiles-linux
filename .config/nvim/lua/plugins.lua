return require("packer").startup({
  ---@param use fun(opts: table)
  ---@param use_rocks fun(rocks: string|string[])
  function(use, use_rocks)
    local plugins_dir = vim.loop.os_getenv("XDG_CONFIG_HOME") .. "/nvim/lua/plugins"
    -- use = WRAP(use)
    -- macros
    local _M = {}
    function _M.cfg(name)
      return 'require("plugins.' .. name .. '")'
    end
    function _M.do_config(fname)
      return 'pcall(dofile, "' .. plugins_dir .. "/" .. fname .. '")'
    end

    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Core plugins
    use_rocks({ "compat53", "penlight", "fun", "stdlib", "luaposix" })
    -- use("tjdevries/astronauta.nvim")
    use({ "nvim-lua/plenary.nvim", config = [[require('plenary.filetype').add_file('user')]] })
    use({ "iamcco/async-await.lua" })
    use({ "norcalli/profiler.nvim" })
    use({ "delphinus/agrp.nvim" })
    use({
      "mortepau/codicons.nvim",
      config = function()
        local codicons = require("codicons")
        codicons.setup()
        local ext = require("codicons.extensions").available()
        require(ext.CompletionItemKind).set()
        vim.g.vim_package_info_virutaltext_prefix = "  " .. codicons.get("versions") .. " "
      end,
    })
    use({ "lewis6991/impatient.nvim", config = 'require("impatient")' })
    use({ "tjdevries/lazy.nvim", module = "lazy" })
    use({
      "ldelossa/litee.nvim",
      module_pattern = "litee.*",
      config = function()
        require("litee.lib").setup({
          tree = { icon_set = "codicons" },
        })
      end,
    })
    -- custom library that i haven't made public yet
    use({ "~/Projects/nvim-plugins/std.nvim" })

    -- Completion & Linting
    use({
      "neovim/nvim-lspconfig",
      requires = { "tamago324/nlsp-settings.nvim", { "lspcontainers/lspcontainers.nvim", module = "lspcontainers" } },
      config = _M.cfg("lspsettings"),
    })
    use({
      "tami5/lspsaga.nvim",
      -- maintained fork of glepnir/lspsaga.nvim
      -- i'll look for a replacement for lspsaga outright at some point
      requires = { "neovim/nvim-lspconfig", "mortepau/codicons.nvim" },
      config = _M.do_config("lspsaga.lua"),
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
        { "nvim-treesitter/playground", after = "nvim-treesitter", as = "nvim-treesitter-playground" },
        { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
        { "nvim-treesitter/nvim-tree-docs", after = "nvim-treesitter", requires = "Olical/aniseed" },
        { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
        { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
        { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
        {
          "mfussenegger/nvim-ts-hint-textobject",
          keys = { { "o", "m" }, { "v", "m" } },
          config = function()
            vim.keymap.set("o", "m", [[:<C-u>lua require('tsht').nodes()<CR>]], { silent = true })
            vim.keymap.set("o", "m", [[<Cmd>lua require('tsht').nodes()<CR>]], { silent = true, noremap = true })
          end,
        },
      },
      run = ":TSUpdate",
      config = _M.do_config("treesitter.lua"),
    })
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-calc",
        "onsails/lspkind-nvim",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "lukas-reineke/cmp-under-comparator",
        "hrsh7th/cmp-emoji",
        { "hrsh7th/cmp-nvim-lua", ft = "lua" },
        {
          "hrsh7th/cmp-vsnip",
          requires = { "hrsh7th/vim-vsnip", { "rafamadriz/friendly-snippets", event = "VimEnter *" } },
          config = [[vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/vsnip"]],
        },
        { "ray-x/cmp-treesitter", requires = "nvim-treesitter/nvim-treesitter" },
        { "hrsh7th/cmp-copilot", requires = "github/copilot.vim" },
        { "tzachar/cmp-tabnine", run = "./install.sh" },
        { "f3fora/cmp-nuspell", rocks = "lua-nuspell" },
        {
          "tzachar/cmp-fuzzy-buffer",
          requires = { { "tzachar/fuzzy.nvim", requires = "nvim-telescope/telescope-fzf-native.nvim" } },
        },
      },
      config = _M.do_config("nvim-cmp.lua"),
    })
    use({
      "mfussenegger/nvim-lint",
      ft = { "markdown", "sh" },
      config = function()
        require("lint").linters_by_ft = {
          markdown = { "markdownlint" },
          sh = { "shellcheck" },
        }
      end,
    })

    use({
      "mfussenegger/nvim-dap",
      requires = {
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        { "Pocco81/DAPInstall.nvim", cmd = { "DIInstall", "DIUninstall", "DIList" }, module = "dap-install" },
        { "theHamsta/nvim-dap-virtual-text", requires = "nvim-treesitter/nvim-treesitter" },
      },
      config = _M.do_config("dap.lua"),
    })

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        -- Telescope dependencies
        "nvim-lua/plenary.nvim",
        { "nvim-lua/popup.nvim", module = "popup", requires = "nvim-lua/plenary.nvim" },
        -- Optional dependencies
        "kyazdani42/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope-symbols.nvim",
        -- Telescope plugins
        "nvim-telescope/telescope-fzf-writer.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "dhruvmanila/telescope-bookmarks.nvim",
        "cwebster2/github-coauthors.nvim",
        "jvgrootveld/telescope-zoxide",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-github.nvim",
        { "tamago324/telescope-sonictemplate.nvim", requires = "mattn/vim-sonictemplate" },
        { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim" },
        { "nvim-telescope/telescope-cheat.nvim", requires = "tami5/sql.nvim" },
        { "nvim-telescope/telescope-dap.nvim", requires = "mfussenegger/nvim-dap" },
        { "nvim-telescope/telescope-smart-history.nvim", requires = "tami5/sql.nvim" },
        {
          "nvim-telescope/telescope-arecibo.nvim",
          requires = "nvim-treesitter/nvim-treesitter",
          rocks = { "openssl", "lua-http-parser" },
        },
        -- NOTE: the WorkspaceFoundNodeProject event isn't implemented yet
        {
          "nvim-telescope/telescope-node-modules.nvim",
          ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescriptcommon" },
          event = { "BufRead package.json", "User WorkspaceFoundNodeProject" },
          config = function()
            require("telescope").load_extension("node_modules")
          end,
        },
        {
          "elianiva/telescope-npm.nvim",
          ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescriptcommon" },
          event = { "BufRead package.json", "User WorkspaceFoundNodeProject" },
          config = function()
            require("telescope").load_extension("npm")
          end,
        },
        {
          "ElPiloto/telescope-vimwiki.nvim",
          requires = "vimwiki/vimwiki",
          ft = "vimwiki",
          config = function()
            require("telescope").load_extension("vimwiki")
          end,
        },
        "LinArcX/telescope-env.nvim",
      },
      config = _M.do_config("telescope.lua"),
    })
    use({
      "pwntester/octo.nvim",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = _M.do_config("octo.lua"),
    })

    -- User interface
    use({
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      event = "VimEnter *",
      config = function()
        require("gitsigns").setup({ current_line_blame = true })
      end,
    })
    use({
      "rhysd/git-messenger.vim",
      cmd = "GitMessenger",
      keys = "<Plug>(git-messenger)",
      setup = function()
        vim.g.git_messenger_no_default_mappings = true
        vim.keymap.set("n", "<Leader>gm", "<Plug>(git-messenger)")
      end,
    })
    use({
      "norcalli/nvim-colorizer.lua",
      ft = { "css", "kitty", "less", "lua", "vim" },
      cmd = "ColorizerToggle",
      config = function()
        require("colorizer").setup({
          "kitty",
          "less",
          css = { css = true },
          lua = { RGB = false, RRGGBB = true, names = false },
          vim = { RGB = false, RRGGBB = true, names = false },
        })
      end,
    })
    use({ "meain/vim-package-info", run = "npm i" }) -- rplugin lazy loads
    use({
      "hoob3rt/lualine.nvim",
      requires = {
        "arkav/lualine-lsp-progress",
        "kyazdani42/nvim-web-devicons",
        "mortepau/codicons.nvim",
      },
      config = _M.do_config("lualine.lua"),
    })
    use({
      "lewis6991/foldsigns.nvim",
      config = function()
        require("foldsigns").setup({ exclude = { "GitSigns.*", "LspSagaLightBulb" } })
      end,
    })
    use({
      "akinsho/nvim-bufferline.lua",
      requires = { "kyazdani42/nvim-web-devicons", "mortepau/codicons.nvim" },
      config = function()
        local codicons = require("codicons")
        require("bufferline").setup({
          options = {
            buffer_close_icon = codicons.get("close"),
            close_icon = codicons.get("close-all"),
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, _)
              return "(" .. count .. ")"
            end,
            separator_style = "slant",
            offsets = { { filetype = "NvimTree", text = "File Explorer" } },
          },
        })
        vim.keymap.set("n", "bb", "<Cmd>BufferLinePick<CR>")
        vim.keymap.set("n", "[b", "<Cmd>BufferLineCycleNext<CR>")
        vim.keymap.set("n", "]b", "<Cmd>BufferLineCyclePrev<CR>")
      end,
    })
    use({
      "folke/tokyonight.nvim",
      config = function()
        vim.g.tokyonight_style = "night"
        vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer", "LspTrouble" }
        vim.cmd("colorscheme tokyonight")
      end,
    })
    use({
      "tkmpypy/chowcho.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      opt = true,
      cmd = "Chowcho",
      config = function()
        require("chowcho").setup({ icon_enabled = true, border_style = "rounded" })
      end,
    })
    use({ "yamatsum/nvim-cursorline", config = 'require("plugins.nvim-cursorline").config()' })
    use({ "alec-gibson/nvim-tetris", cmd = "Tetris" })
    use({ "dstein64/nvim-scrollview" })
    use({ "kevinhwang91/nvim-hlslens", config = _M.do_config("nvim-hlslens.lua") })
    use({
      "lukas-reineke/indent-blankline.nvim",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        vim.g.indent_blankline_buftype_exclude = { "terminal" }
        vim.g.indent_blankline_filetype_exclude = { "alpha", "help", "lspinfo", "packer", "peek" }
        vim.g.indent_blankline_char = "▏"
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indent_blankline_show_current_context = true
        vim.g.indent_blankline_context_patterns = {
          "class",
          "return",
          "function",
          "method",
          "^if",
          "^while",
          "jsx_element",
          "^for",
          "^object",
          "^table",
          "block",
          "arguments",
          "if_statement",
          "else_clause",
          "jsx_element",
          "jsx_self_closing_element",
          "try_statement",
          "catch_clause",
          "import_statement",
        }
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_show_trailing_blankline_indent = false
      end,
    })
    use("karb94/neoscroll.nvim") -- Smooth scrolling
    use({
      "edluffy/specs.nvim",
      config = function()
        require("specs").setup({ popup = { fader = require("specs").pulse_fader } })
      end,
    })
    -- use {'sunjon/shade.nvim', config = function() require('shade').setup() end}
    -- Turned off because it breaks some random highlights (how?)
    use({ "folke/which-key.nvim", config = _M.do_config("which-key.lua") })
    use({
      "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap", "mortepau/codicons.nvim" },
      config = function()
        local has_codicons, codicons = pcall(require, "codicons")
        require("dapui").setup({
          icons = {
            expanded = has_codicons and codicons.get("chevron-down") or "⯆",
            collapsed = has_codicons and codicons.get("chevron-right") or "⯈",
            circular = has_codicons and codicons.get("refresh") or "↺",
          },
        })
      end,
    })
    use({
      "winston0410/range-highlight.nvim",
      requires = "winston0410/cmd-parser.nvim",
      event = "VimEnter *",
      config = function()
        require("range-highlight").setup({})
      end,
    })
    use({
      "goolord/alpha-nvim",
      config = function()
        require("alpha").setup(require("alpha.themes.dashboard").opts)
      end,
    })
    use({ "rcarriga/nvim-notify", config = [[require("telescope").load_extension("notify")]], module = "notify" })
    use({
      "lukas-reineke/headlines.nvim",
      ft = { "markdown", "rmd", "vimwiki", "orgmode" },
      config = function()
        require("headlines").setup()
      end,
    })

    -- Utilities
    use({
      "tpope/vim-fugitive",
      config = function()
        vim.g.fugitive_legacy_commands = false
        vim.g.fugitive_no_maps = true
      end,
    })
    use({
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      keys = { { "n", "<Leader>gy" }, { "v", "<Leader>gy" } },
      config = function()
        require("gitlinker").setup()
      end,
    })
    use({
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      cmd = "Neogit",
      config = function()
        require("neogit").setup({ disable_signs = true })
      end,
    })
    use("farmergreg/vim-lastplace")
    -- VimWiki - note-taking engine
    use({
      "vimwiki/vimwiki",
      -- event = "BufNewFile,BufRead *.markdown,*.mdown,*.mdwn,*.wiki,*.mkdn,*.mw,*.md",
      -- cmd = {
      --   "VimwikiIndex",
      --   "VimwikiTabIndex",
      --   "VimwikiDiaryIndex",
      --   "VimwikiMakeDiaryNote",
      --   "VimwikiTabMakeDiaryNote",
      -- },
      -- keys = {
      --   "<Plug>VimwikiIndex",
      --   "<Plug>VimwikiTabIndex",
      --   "<Plug>VimwikiUISelect",
      --   "<Plug>VimwikiDiaryIndex",
      --   "<Plug>VimwikiDiaryGenerateLinks",
      --   "<Plug>VimwikiMakeDiaryNote",
      --   "<Plug>VimwikiTabMakeDiaryNote",
      --   "<Plug>VimwikiMakeYesterdayDiaryNote",
      --   "<Plug>VimwikiMakeTomorrowDiaryNote",
      -- },
      config = function()
        vim.g.vimwiki_list = { { path = "~/Documents/VimWiki", nested_syntaxes = { ["c++"] = "cpp" } } }
        vim.g.vimwiki_folding = "expr"
        vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_hl_headers = 1
        vim.g.vimwiki_key_mappings = { global = false }
        vim.keymap.set("n", "<Leader>ww", "<Plug>VimwikiIndex")
        vim.keymap.set("n", "<Leader>wt", "<Plug>VimwikiTabIndex")
      end,
    })
    -- neuron.nvim - Neuron-based note-taking engine
    -- this might replace vimwiki at some point
    use({
      "oberblastmeister/neuron.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
      keys = { { "n", "gzi" } },
      config = function()
        require("neuron").setup({
          virtual_titles = true,
          mappings = true,
          run = nil,
          neuron_dir = "~/Documents/Neuron",
          leader = "gz",
        })
      end,
    })
    use({
      "hkupty/iron.nvim",
      cmd = { "IronRepl", "IronSend", "IronReplHere", "IronWatchCurrentFile" },
      keys = {
        "<Plug>(iron-repeat-cmd)",
        "<Plug>(iron-cr)",
        "<Plug>(iron-interrupt)",
        "<Plug>(iron-exit)",
        "<Plug>(iron-clear)",
        "<Plug>(iron-send-motion)",
        "<Plug>(iron-send-lines)",
        "<Plug>(iron-send-line)",
        "<Plug>(iron-visual-send)",
      },
      setup = function()
        vim.g.iron_map_defaults = false
        vim.g.iron_map_extended = false
        vim.keymap.set("n", "ctr", "<Plug>(iron-send-motion)")
        vim.keymap.set("v", "ctr", "<Plug>(iron-visual-send)")
        vim.keymap.set("n", "<LocalLeader>sl", "<Plug>(iron-send-line)")
      end,
      config = _M.do_config("iron.lua"),
    })
    use({ "mhartington/formatter.nvim", event = "VimEnter *", config = _M.do_config("formatter.lua") })
    use({
      "sudormrfbin/cheatsheet.nvim",
      requires = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-lua/popup.nvim", module = "popup", requires = "nvim-lua/plenary.nvim" },
      },
      cmd = { "Cheatsheet", "CheatsheetEdit" },
      setup = function()
        vim.keymap.set("n", "<Leader>?", [[:<C-U>Cheatsheet<CR>]], { silent = true, noremap = true })
      end,
    })
    use({ "lambdalisue/guise.vim", requires = "vim-denops/denops.vim" })
    use({ "lambdalisue/askpass.vim", requires = "vim-denops/denops.vim" })
    use({
      "luukvbaal/stabilize.nvim",
      config = function()
        require("stabilize").setup()
      end,
    })

    -- ultest - unit test support
    -- lazy loading is very janky
    use({
      "rcarriga/vim-ultest",
      requires = "vim-test/vim-test",
      run = ":UpdateRemotePlugins",
      opt = true,
      cmd = { "Ultest", "UltestNearest", "UltestSummary" },
      keys = { "<Plug>(ultest-run-file)", "<Plug>(ultest-run-nearest)" },
      config = function()
        vim.cmd("silent UpdateRemotePlugins")
        vim.cmd("au init User UltestPositionsUpdate ++once UltestNearest")
      end,
    })
    -- vim-sonictemplate - Template engine
    -- fn load condition allows for telescope integration to load this
    use({
      "mattn/vim-sonictemplate",
      cmd = "Template",
      fn = "sonictemplate#complete",
      keys = { "<Plug>(sonictemplate)", "<Plug>(sonictemplate-intelligent)" },
      setup = function()
        vim.keymap.set("n", "<C-y>t", "<Plug>(sonictemplate)")
        vim.keymap.set("n", "<C-y>T", "<Plug>(sonictemplate-intelligent)")
      end,
    })
    use({
      "numToStr/Navigator.nvim",
      config = function()
        local Navigator = require("Navigator")
        Navigator.setup()
        vim.keymap.set("n", "<C-h>", Navigator.left, { noremap = true, silent = true })
        vim.keymap.set("n", "<C-j>", Navigator.down, { noremap = true, silent = true })
        vim.keymap.set("n", "<C-k>", Navigator.up, { noremap = true, silent = true })
        vim.keymap.set("n", "<C-l>", Navigator.right, { noremap = true, silent = true })
        vim.keymap.set("n", "<C-\\>", Navigator.previous, { noremap = true, silent = true })
      end,
    })

    use({
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      config = function()
        require("zen-mode").setup({ plugins = { gitsigns = { enabled = true } } })
      end,
    })
    use({
      "wfxr/minimap.vim",
      cmd = "Minimap",
      setup = function()
        vim.g.minimap_block_filetypes = {
          "ale-fix-suggest",
          "ale-preview-selection",
          "ale-preview",
          "fugitive",
          "LuaTree",
          "tsplayground",
          "vista",
          "vista_kind",
          "vista_markdown",
        }
      end,
    })
    -- vista.vim - TOC & symbol tree
    use({
      "liuchengxu/vista.vim",
      cmd = "Vista",
      setup = require("plugins.vista").setup,
      config = require("plugins.vista").config,
    })
    -- nvim-tree.lua - File tree
    -- Part of this loader is deferred, so we can push a slow step back
    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons", "mortepau/codicons.nvim" },
      opt = true,
      cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
      setup = function()
        vim.g.nvim_tree_lsp_diagnostics = true
      end,
      config = _M.do_config("nvim-tree.lua"),
    })
    use({
      "folke/lsp-trouble.nvim",
      requires = { "neovim/nvim-lspconfig", "kyazdani42/nvim-web-devicons", "mortepau/codicons.nvim" },
      cmd = { "LspTrouble", "LspTroubleToggle" },
      opt = true,
      config = function()
        local codicons = require("codicons")
        require("trouble").setup({
          fold_open = codicons.get("fold-down"),
          fold_closed = codicons.get("fold-up"),
          signs = {
            error = codicons.get("error"),
            warning = codicons.get("warning"),
            hint = codicons.get("question"),
            information = codicons.get("info"),
          },
        })
      end,
    })
    use({
      "simrat39/symbols-outline.nvim",
      requires = { "neovim/nvim-lspconfig", "mortepau/codicons.nvim" },
      cmd = "SymbolsOutline",
      config = _M.do_config("symbols-outline.lua"),
    })
    use({
      "michaelb/sniprun",
      cmd = { "SnipRun", "SnipInfo" },
      keys = { "<Plug>SnipRun", "<Plug>SnipRunOperator", "<Plug>SnipInfo" },
      run = "bash ./install.sh",
      config = function()
        require("sniprun").initial_setup({
          interpreter_options = {
            C_original = { compiler = "clang" },
            Cpp_original = { compiler = "clang++ --debug" },
          },
        })
      end,
    })
    use({
      "sindrets/diffview.nvim",
      cmd = "DiffviewOpen",
      requires = "kyazdani42/nvim-web-devicons",
      opt = true,
      config = _M.do_config("diffview.lua"),
    })
    use({
      "folke/todo-comments.nvim",
      requires = { "nvim-lua/plenary.nvim", "lsp-trouble.nvim", "nvim-telescope/telescope.nvim" },
      cmd = { "TodoQuickFix", "TodoTelescope", "TodoTrouble" },
      config = function()
        require("todo-comments").setup()
      end,
    })
    use({ "NTBBloodbath/rest.nvim", requires = "nvim-lua/plenary.nvim", keys = "<Plug>RestNvim" })
    use({ "Pocco81/HighStr.nvim", cmd = "HSHighlight" })
    use({
      "winston0410/mark-radar.nvim",
      config = function()
        require("mark-radar").setup()
      end,
    })
    -- use({'Pocco81/AutoSave.nvim', config = [[require('autosave').setup()]]})
    use({ "notomo/gesture.nvim", config = _M.do_config("gesture.lua") })
    use({
      "ldelossa/litee-calltree.nvim",
      module = "litee.calltree",
      cmd = {
        "LTOpenToCalltree",
        "LTPopOutCalltree",
        "LTNextCalltree",
        "LTPrevCalltree",
        "LTExpandCalltree",
        "LTFocusCalltree",
        "LTSwitchCalltree",
        "LTJumpCalltree",
        "LTJumpCalltreeSplit",
        "LTJumpCalltreeVSplit",
        "LTJumpCalltreeTab",
        "LTHoverCalltree",
        "LTDetailsCalltree",
        "LTDumpTreeCalltree",
        "LTDumpNodeCalltree",
      },
      requires = { "ldelossa/litee.nvim" },
      config = function()
        require("litee.calltree").setup({})
      end,
    })

    -- Filetypes & language features
    -- Some of this stuff isn't managed by packer.
    use({
      { "leafo/moonscript-vim", ft = "moon" },
      { "rhysd/vim-llvm", ft = { "llvm", "mlir", "tablegen" } },
      { "ron-rs/ron.vim", ft = "ron" },
      { "bakpakin/fennel.vim", ft = "fennel" },
      "aklt/plantuml-syntax",
      { "tikhomirov/vim-glsl", ft = { "glsl", "elm", "html" } },
      { "udalov/kotlin-vim", ft = "kotlin" },
      { "YaBoiBurner/requirements.txt.vim", ft = "requirements" },
      { "teal-language/vim-teal", ft = "teal" },
      { "gluon-lang/vim-gluon", ft = "gluon" },
      { "thyrgle/vim-dyon", ft = "dyon" },
      { "bytecodealliance/cranelift.vim", ft = "clif" },
      { "NoahTheDuke/vim-just", ft = "just" },
      { "abhishekmukherg/xonsh-vim" },
    })
    -- Meson syntax is now manually maintained
    -- toml is handled internally + with nvim-treesitter
    -- vim-teal is patched
    -- fish is handled internally + with nvim-treesitter
    -- cranelift.vim, vim-gluon, vim-dyon - ftdetect removed

    -- CXX
    use({ "jackguo380/vim-lsp-cxx-highlight", ft = { "c", "cpp", "objc", "objcpp", "cc", "cuda" } })

    -- Lua
    -- use 'tjdevries/manillua.nvim'
    use({ "tjdevries/nlua.nvim", ft = "lua" })
    use({ "bfredl/nvim-luadev", cmd = "Luadev" })
    use({ "rafcamlet/nvim-luapad", cmd = { "Lua", "Luapad", "LuaRun" } })
    use({ "milisims/nvim-luaref", "nanotee/luv-vimdocs" })
    use({ "folke/lua-dev.nvim", opt = true })

    -- Markdown
    use({ "plasticboy/vim-markdown", ft = "markdown" })
    use({ "npxbr/glow.nvim", ft = { "markdown", "pandoc.markdown", "rmd" } })
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = "markdown" })
    use({ "kat0h/bufpreview.vim", requires = "vim-denops/denops.vim" })

    -- Org
    -- use({'kristijanhusak/orgmode.nvim', config = [[require('orgmode').setup()]]})
    -- use({
    --   'akinsho/org-bullets.nvim',
    --   ft = 'org',
    --   requires = 'orgmode.nvim',
    --   config = [[require("org-bullets").setup()]],
    -- })

    -- Python
    use({
      "mfussenegger/nvim-dap-python",
      ft = "python",
      requires = "mfussenegger/nvim-dap",
      config = function()
        require("dap-python").setup()
      end,
    })

    -- RST
    -- sphinx.nvim - Sphinx integration
    -- I just have this for tree-sitter stuff
    use({
      "stsewd/sphinx.nvim",
      ft = "rst",
      config = function()
        vim.cmd("delcommand SphinxRefs")
        vim.cmd("delcommand SphinxFiles")
      end,
    })

    -- Rust
    -- rust-tools.nvim - LSP plugin
    -- has a very slow startup time, but rust-analyzer crashes if this is lazy-loaded.
    use({
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        { "nvim-lua/popup.nvim", module = "popup", requires = "nvim-lua/plenary.nvim" },
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("rust-tools").setup({})
      end,
    })
    use({
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      requires = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
    })

    -- YAML
    use({
      "cuducos/yaml.nvim",
      ft = "yaml",
      requires = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
    })

    -- Vim
    use("danilamihailov/vim-tips-wiki")

    -- Integration
    -- editorconfig-vim - Editorconfig support
    -- Rules that will modify files are disabled, since that's handled elsewhere.
    -- Eventually I'll find or make a unified formatting plugin to replace this.
    use({ "editorconfig/editorconfig-vim", config = require("plugins.editorconfig-vim").config })
    use({ "numToStr/FTerm.nvim", config = _M.do_config("fterm.lua") })
    use({ "gennaro-tedesco/nvim-jqx", cmd = { "JqxList", "JqxQuery" }, keys = "<Plug>JqxList" })
    use({ "kdheepak/lazygit.nvim", requires = "nvim-lua/plenary.nvim", cmd = "LazyGit" })
    -- use {'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end}
    -- Spell support for tree-sitter is nice but it causes files to noticably refresh constantly.
    -- It also might be contributing to PID bloat by running hunspell too often.
    -- It's a WIP so some problems can be expected.
    use({ "jamestthompson3/nvim-remote-containers", cmd = { "AttachToContainer", "BuildImage" } })
    -- use({ "andweeb/presence.nvim" })
    use({ "kristijanhusak/vim-carbon-now-sh", cmd = "CarbonNowSh" })
    use({
      "rlch/github-notifications.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
      config = function()
        require("github-notifications").setup()
        require("telescope").load_extension("ghn")
      end,
    })
    -- use({ "skanehira/denops-docker.vim", requires = "vim-denops/denops.vim" })

    -- Text editing
    use({ "tpope/vim-repeat" })
    use({ "ggandor/lightspeed.nvim" })
    -- hop.nvim - EasyMotion replacement
    use({
      "phaazon/hop.nvim",
      cmd = { "HopWord", "HopPattern", "HopChar1", "HopChar2", "HopLine" },
      setup = function()
        vim.keymap.set("n", "<Leader>hw", "<Cmd>HopWord<CR>")
        vim.keymap.set("n", "<Leader>hp", "<Cmd>HopPattern<CR>")
        vim.keymap.set("n", "<Leader>hc", "<Cmd>HopChar1<CR>")
        vim.keymap.set("n", "<Leader>hC", "<Cmd>HopChar2<CR>")
        vim.keymap.set("n", "<Leader>hl", "<Cmd>HopLine<CR>")
      end,
    })
    use({
      "windwp/nvim-autopairs",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        local npairs = require("nvim-autopairs")
        npairs.setup({
          check_ts = true,
          ts_config = { lua = { "string" }, javascript = { "template_string" } },
        })
      end,
    })
    use({
      "tpope/vim-abolish",
      cmd = { "Abolish", "Subvert", "S" },
      keys = { "<Plug>(abolish-coerce)", "<Plug>(abolish-coerce-word)" },
      setup = function()
        vim.g.abolish_no_mappings = true
        vim.g.abolish_save_file = vim.fn.stdpath("config") .. "/after/plugin/abolish.vim"
        vim.keymap.set("n", "cr", "<Plug>(abolish-coerce-word)")
      end,
    })
    use({
      "tpope/vim-commentary",
      cmd = "Commentary",
      keys = { "<Plug>Commentary", "<Plug>CommentaryLine", "<Plug>ChangeCommentary" },
      setup = function()
        vim.keymap.set("x", "gc", "<Plug>Commentary")
        vim.keymap.set("n", "gc", "<Plug>Commentary")
        vim.keymap.set("o", "gc", "<Plug>Commentary")
        vim.keymap.set("n", "gcc", "<Plug>CommentaryLine")
        vim.keymap.set("n", "gcu", "<Plug>Commentary<Plug>Commentary")
      end,
    })
    -- vim-surround
    -- This could be replaced by blackCauldron7/surround.nvim eventually
    use({
      "tpope/vim-surround",
      keys = {
        "<Plug>Dsurround",
        "<Plug>Csurround",
        "<Plug>CSurround",
        "<Plug>Ysurround",
        "<Plug>YSurround",
        "<Plug>Yssurround",
        "<Plug>YSsurround",
        "<Plug>VSurround",
        "<Plug>VgSurround",
        { "i", "<Plug>Isurround" },
        { "i", "<Plug>ISurround" },
      },
      setup = function()
        vim.g.surround_no_mappings = true
        vim.keymap.set("n", "ds", "<Plug>Dsurround")
        vim.keymap.set("n", "cs", "<Plug>Csurround")
        vim.keymap.set("n", "cS", "<Plug>CSurround")
        vim.keymap.set("n", "Ys", "<Plug>Ysurround")
        vim.keymap.set("n", "YS", "<Plug>YSurround")
        vim.keymap.set("n", "Yss", "<Plug>Yssurround")
        vim.keymap.set("n", "YSs", "<Plug>YSsurround")
        vim.keymap.set("n", "YSS", "<Plug>YSsurround")
        vim.keymap.set("x", "S", "<Plug>VSurround")
        vim.keymap.set("x", "gS", "<Plug>VgSurround")
        vim.keymap.set("i", "<C-S>", "<Plug>Isurround")
        vim.keymap.set("i", "<C-G>s", "<Plug>Isurround")
        vim.keymap.set("i", "<C-G>S", "<Plug>ISurround")
      end,
    })
    -- dial.nvim - Replaces speeddating
    use({
      "~/Projects/nvim-plugins/dial.nvim",
      keys = { "<C-a>", "<C-x>", { "v", "g<C-a>" }, { "v", "g<C-x>" } },
      config = _M.do_config("dial.lua"),
    })
    use({
      "AndrewRadev/splitjoin.vim",
      cmd = { "SplitjoinSplit", "SplitjoinJoin" },
      keys = { { "n", "gJ" }, { "n", "gS" } },
    })
    use({
      "junegunn/vim-easy-align",
      cmd = { "EasyAlign", "LiveEasyAlign" },
      keys = { "<Plug>(EasyAlign)", "<Plug>(LiveEasyAlign)" },
      setup = function()
        vim.keymap.set("v", "ga", "<Plug>(LiveEasyAlign)", { silent = true })
        vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { silent = true })
      end,
    })
    use({
      "dkarter/bullets.vim",
      ft = { "markdown", "gitcommit" },
      setup = function()
        vim.g.bullets_enabled_file_types = { "markdown", "gitcommit" }
      end,
    })
    use({
      "kana/vim-textobj-function",
      -- Can act up when lazy-loaded
      requires = "kana/vim-textobj-user",
      keys = {
        { "x", "af" },
        { "o", "af" },
        { "x", "if" },
        { "o", "if" },
        { "x", "aF" },
        { "o", "aF" },
        { "x", "iF" },
        { "o", "iF" },
      },
    })
    use({
      "sgur/vim-textobj-parameter",
      requires = "kana/vim-textobj-user",
      keys = { { "x", "a," }, { "o", "a," }, { "x", "i," }, { "o", "i," }, { "x", "i2," }, { "o", "i2," } },
    })
    use({
      "rsrchboy/vim-textobj-heredocs",
      requires = "kana/vim-textobj-user",
      keys = { { "x", "aH" }, { "o", "aH" }, { "x", "iH" }, { "o", "iH" } },
    })
    use({ "jbyuki/venn.nvim", event = "OptionSet virtualedit", cmd = "VBox" })
    use({
      "mizlan/iswap.nvim",
      requires = "nvim-treesitter/nvim-treesitter",
      cmd = "ISwap",
      config = function()
        require("iswap").setup({})
      end,
    })
  end,
  config = { max_jobs = #vim.loop.cpu_info(), profile = { enable = true, threshold = 1 } },
})
