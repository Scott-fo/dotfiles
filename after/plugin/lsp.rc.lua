local lsp_zero = require('lsp-zero')
local blink      = require("blink.cmp")
local cmp_caps   = blink.get_lsp_capabilities()

local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set('n', 'gn', function() vim.lsp.buf.rename() end, opts)

  -- Diagnostics
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', 'ge', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
  vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', 'ca', function() vim.lsp.buf.code_action() end, opts)

  vim.diagnostic.config({
    virtual_text = true,
  })
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    -- default handler
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = cmp_caps,
      })
    end,

    -- html
    ["html"] = function()
      require("lspconfig").html.setup({
        filetypes    = { "html", "eruby", "erb", "heex", "ex" },
        capabilities = cmp_caps,
      })
    end,

    -- tailwindcss
    ["tailwindcss"] = function()
      require("lspconfig").tailwindcss.setup({
        filetypes    = {
          "html", "eruby", "erb", "heex", "ex", "jsx", "tsx"
        },
        capabilities = cmp_caps,
      })
    end,

    -- ts_ls (tsserver)
    ["ts_ls"] = function()
      require("lspconfig").ts_ls.setup({
        init_options = {
          plugins = {
            {
              name     = "@vue/typescript-plugin",
              location = "/path/to/@vue/language-server",
              languages = { "vue" },
            },
          },
        },
        capabilities = cmp_caps,
      })
    end,

    -- volar
    ["volar"] = function()
      require("lspconfig").volar.setup({
        init_options = {
          vue = { hybridMode = false },
        },
        capabilities = cmp_caps,
      })
    end,
  },
})

require("conform").setup({
  formatters_by_ft = {
    eruby = { "erb_format" },
    ruby = { "standardrb" },
    rust = { "rustfmt", lsp_format = "fallback" },
    go = { "goimports", "gofmt" },
    javascript = { "prettierd", "eslint_d" },
    typescript = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    python = { "black" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
