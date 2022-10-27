local present, catppuccin = pcall(require, "catppuccin")
if not present then return end

vim.g.catppuccin_flavour = "macchiato"

catppuccin.setup {
	term_colors = true,
	compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
	styles = {
		comments = {},
		conditionals = {},
	},
  integrations = {
    treesitter = false,
    cmp = true,
    gitsigns = true,
    telescope = true,
    lsp_saga = true,
  }
}

vim.api.nvim_command "colorscheme catppuccin"
