-- vim.o.completeopt = 'menu,menuone,noselect'
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.register_source('fish', require('cmp_fish').new())

cmp.setup({
  completion = {completeopt = 'menu,menuone,noselect'},
  snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
  },
  sources = cmp.config.sources({
    {name = 'nvim_lsp'}, {name = 'vsnip'}, {name = 'buffer'}, {name = 'cmp_tabnine'},
    {name = 'treesitter'}, {name = 'spell'}, {name = 'crates'}, {name = 'nvim_lua'},
    {name = 'calc'}, {name = 'fish'}, {name = 'copilot'}, {name = 'fuzzy_buffer'},
  }),
  formatting = {format = lspkind.cmp_format({with_text = true, maxwidth = 50})},
})

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({{name = 'nvim_lsp_document_symbol'}},
                               {{name = 'fuzzy_buffer'}, {name = 'buffer'}}),
})

-- cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})

local has_cmp_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if has_cmp_autopairs then
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = {tex = ''}}))
end
