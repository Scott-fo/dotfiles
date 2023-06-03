local status, mason = pcall(require, 'mason')
if (not status) then return end

local status2, lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

mason.setup{}
lspconfig.setup {
  ensure_installed = { 'tailwindcss', 'gopls', 'rust_analyzer' }
}

require'lspconfig'.intelephense.setup{}
require'lspconfig'.astro.setup{}
require'lspconfig'.pylsp.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.tailwindcss.setup {}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.elixirls.setup{
  cmd = {"/home/scottfo/.elixir-ls/language_server.sh"};
}
require'lspconfig'.ols.setup({})
require'lspconfig'.zls.setup{}
