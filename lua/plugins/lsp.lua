return {
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
  },
  { 'onsails/lspkind-nvim' },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
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
