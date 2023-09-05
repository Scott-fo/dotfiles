local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'gopls',
    'rust_analyzer',
    "rust_analyzer",
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

local status, cmp = pcall(require, "cmp")
if (not status) then return end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' }
    }),
})

lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    lsp.buffer_autoformat()

    -- Definitions
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set('n', 'ca', function() vim.lsp.buf.code_action() end, opts)

    -- Actions
    vim.keymap.set('n', 'gn', function() vim.lsp.buf.rename() end, opts)

    -- Diagnostics
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', 'ge', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
    vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, opts)
end)

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
