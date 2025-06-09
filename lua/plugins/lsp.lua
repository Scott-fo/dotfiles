return {
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
  },
  { 'onsails/lspkind-nvim' },
  { "mason-org/mason.nvim", version = "1.11.0" },
 { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
  { 'stevearc/conform.nvim', opts = {} },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'enter' },
      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = { documentation = { auto_show = true } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "rust" },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  },
}
