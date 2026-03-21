local lsp_group = vim.api.nvim_create_augroup("dotfiles-lsp", { clear = true })

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "x" }, "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)
    vim.keymap.set("n", "ge", function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local clients = vim.lsp.get_clients({
      bufnr = args.buf,
      method = "textDocument/formatting",
    })

    if #clients == 0 then
      return
    end

    vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 500 })
  end,
})

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Add per-server configs under `lsp/<server>.lua`, then enable them here.
-- Example: vim.lsp.enable("lua_ls")
