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
    local function cmd(bin)
      return 'vim.fn.executable("' .. bin .. '") == 1'
    end
    local function telescope(extension)
      return [[require("telescope").load_extension("]] .. extension .. [[")]]
    end

    -- Packer can manage itself
    use({ "wbthomason/packer.nvim" })

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
        codicons.setup({})
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
      requires = { "tamago324/nlsp-settings.nvim" },
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
      { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = _M.do_config("treesitter.lua") },
      { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
      { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
      { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
      {
        "mfussenegger/nvim-treehopper",
        requires = "nvim-treesitter",
        keys = { { "o", "m" }, { "v", "m" } },
        config = function()
          vim.keymap.set("o", "m", [[:<C-u>lua require('tsht').nodes()<CR>]], { silent = true })
          vim.keymap.set("o", "m", [[<Cmd>lua require('tsht').nodes()<CR>]], { silent = true, noremap = true })
        end,
      },
    })
    use({
      { "hrsh7th/nvim-cmp", config = _M.do_config("nvim-cmp.loa") },
      { "hrsh7th/cmp-buffer", requires = "nvim-cmp" },
      { "hrsh7th/cmp-path", requires = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", requires = "nvim-cmp" },
      { "hrsh7th/cmp-calc", requires = "nvim-cmp" },
      { "onsails/lspkind-nvim", requires = "nvim-cmp" },
      { "f3fora/cmp-spell", requires = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp", requires = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol", requires = "nvim-cmp" },
      { "lukas-reineke/cmp-under-comparator", tag = "v1.*", requires = "nvim-cmp" },
      { "hrsh7th/cmp-emoji", requires = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", requires = "nvim-cmp", ft = "lua" },
      { "mtoohey31/cmp-fish", requires = "nvim-cmp", ft = "fish", cond = cmd("fish") },
      { "ray-x/cmp-treesitter", requires = { "nvim-cmp", "nvim-treesitter" } },
      { "hrsh7th/cmp-copilot", requires = { "nvim-cmp", "github/copilot.vim" } },
      {
        "tzachar/cmp-fuzzy-buffer",
        requires = { "nvim-cmp", { "tzachar/fuzzy.nvim", requires = "nvim-telescope/telescope-fzf-native.nvim" } },
      },
    })
    use({
      {
        "hrsh7th/vim-vsnip",
        config = [[vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/vsnip"]],
      },
      { "hrsh7th/cmp-vsnip", requires = { "vim-vsnip", "nvim-cmp" } },
      { "rafamadriz/friendly-snippets", requires = "vim-vsnip", event = "VimEnter *" },
    })
    use({
      "mfussenegger/nvim-lint",
      ft = { "markdown", "sh", "dockerfile", "lua", "vim", "yaml" },
      config = function()
        require("lint").linters_by_ft = {
          dockerfile = { "hadolint" },
          lua = { "selene" },
          markdown = { "markdownlint" },
          sh = { "shellcheck" },
          vim = { "vint" },
          yaml = { "yamllint" },
        }
      end,
    })

    -- Telescope
    use({
      {
        "nvim-telescope/telescope.nvim",
        tag = "0.*",
        requires = { "nvim-lua/plenary.nvim", "nvim-treesitter", "kyazdani42/nvim-web-devicons" },
        config = _M.do_config("telescope.lua"),
      },
      { "nvim-telescope/telescope-symbols.nvim", requires = "telescope.nvim" },
      { "cwebster2/github-coauthors.nvim", requires = "telescope.nvim", config = telescope("githubcoauthors") },
      { "LinArcX/telescope-env.nvim", requires = "telescope.nvim", config = telescope("env") },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make", -- requires cmake but we won't check for it to save time
        requires = "telescope.nvim",
        config = telescope("fzf"),
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        requires = { "telescope.nvim", "tami5/sql.nvim" },
        config = telescope("frecency"),
      },
      {
        "jvgrootveld/telescope-zoxide",
        after = "telescope.nvim",
        cond = cmd("zoxide"),
        config = telescope("zoxide"),
      },
    })

    -- User interface
    use({
      { "dstein64/nvim-scrollview" }, -- scroll bar
      { "karb94/neoscroll.nvim" }, -- Smooth scrolling
    })
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
      "akinsho/bufferline.nvim",
      tag = "v2.*",
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
        require("tokyonight").setup({
          style = "night",
          sidebars = { "qf", "help", "vista_kind", "terminal", "packer", "LspTrouble" },
        })
        vim.cmd("colorscheme tokyonight")
      end,
    })
    use({ "kevinhwang91/nvim-hlslens", config = _M.do_config("nvim-hlslens.lua") })
    use({
      "lukas-reineke/indent-blankline.nvim",
      tag = "v2.*",
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
    -- use({ "rcarriga/nvim-notify", config = [[require("telescope").load_extension("notify")]], module = "notify" })

    -- Utilities
    use({
      { "farmergreg/vim-lastplace" },
      { "lambdalisue/guise.vim", tag = "v0.*", requires = "vim-denops/denops.vim" },
      { "lambdalisue/askpass.vim", requires = "vim-denops/denops.vim" },
    })
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
    use({ "mhartington/formatter.nvim", event = "VimEnter *", config = _M.do_config("formatter.lua") })
    use({
      "luukvbaal/stabilize.nvim",
      config = function()
        require("stabilize").setup()
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
    -- vista.vim - TOC & symbol tree
    use({
      "liuchengxu/vista.vim",
      cmd = "Vista",
      setup = require("plugins.vista").setup,
      config = require("plugins.vista").config,
    })
    -- nvim-tree.lua - File tree
    -- Part of this loader is deferred, so we can push a slow step back
    -- use({
    --   "kyazdani42/nvim-tree.lua",
    --   requires = { "kyazdani42/nvim-web-devicons", "mortepau/codicons.nvim" },
    --   opt = true,
    --   cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    --   setup = function()
    --     vim.g.nvim_tree_lsp_diagnostics = true
    --   end,
    --   config = _M.do_config("nvim-tree.lua"),
    -- })
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
    -- use({ "NTBBloodbath/rest.nvim", requires = "nvim-lua/plenary.nvim", keys = "<Plug>RestNvim" })
    use({
      "winston0410/mark-radar.nvim",
      config = function()
        require("mark-radar").setup()
      end,
    })
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
      { "leafo/moonscript-vim" },
      { "ron-rs/ron.vim", ft = "ron" },
      { "bakpakin/fennel.vim", ft = "fennel" },
      { "teal-language/vim-teal", ft = "teal" },
      { "gluon-lang/vim-gluon" },
      { "thyrgle/vim-dyon", ft = "dyon" },
      { "NoahTheDuke/vim-just", ft = "just" },
      { "abhishekmukherg/xonsh-vim" },
      { "~/Projects/nvim-plugins/adblock-syntax.vim", ft = "abp" },
    })
    -- Meson syntax is now manually maintained
    -- toml is handled internally + with nvim-treesitter
    -- vim-teal is patched
    -- fish is handled internally + with nvim-treesitter
    -- cranelift.vim, vim-gluon, vim-dyon - ftdetect removed

    -- Lua
    use({
      { "tjdevries/nlua.nvim", ft = "lua" },
      { "bfredl/nvim-luadev", cmd = "Luadev" },
      { "rafcamlet/nvim-luapad", cmd = { "Lua", "Luapad", "LuaRun" } },
      { "milisims/nvim-luaref", "nanotee/luv-vimdocs" },
      { "folke/lua-dev.nvim", opt = true },
    })

    -- Vim
    use({ "danilamihailov/vim-tips-wiki" })

    -- Integration
    -- editorconfig-vim - Editorconfig support
    -- Rules that will modify files are disabled, since that's handled elsewhere.
    -- Eventually I'll find or make a unified formatting plugin to replace this.
    use({ "editorconfig/editorconfig-vim", config = require("plugins.editorconfig-vim").config })
    -- use({ "numToStr/FTerm.nvim", config = _M.do_config("fterm.lua") })

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
      "monaqa/dial.nvim",
      requires = "nvim-lua/plenary.nvim",
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
