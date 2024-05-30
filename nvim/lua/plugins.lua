local status, packer = pcall(require, 'packer')
if (not status) then
  print("packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { 'hrsh7th/cmp-buffer' },       -- Optional
      { 'hrsh7th/cmp-path' },         -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' },     -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' },             -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional
    }
  }
  use 'nvim-tree/nvim-web-devicons'
  use 'wbthomason/packer.nvim'
  use 'onsails/lspkind-nvim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'nvim-lua/plenary.nvim'
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
  }
  use {
    after = "catppuccin",
    'akinsho/bufferline.nvim',
  }
  use 'feline-nvim/feline.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
  }
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'
  use 'ziglang/zig.vim'
end)
