local lsp_group = vim.api.nvim_create_augroup("dotfiles-lsp", { clear = true })
local js_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}
local js_root_markers = {
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
  ".git",
}
local blink = require("blink.cmp")
local function snacks_picker(method)
  return function()
    require("snacks").picker[method]()
  end
end

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
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf }
    local picker_opts = { buffer = args.buf, nowait = true }

    if client and client.name == "vtsls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", snacks_picker("lsp_implementations"), picker_opts)
    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", snacks_picker("lsp_references"), picker_opts)
    vim.keymap.set("n", "<A-t>", snacks_picker("lsp_type_definitions"), picker_opts)
    vim.keymap.set("n", "<D-l>", snacks_picker("lsp_workspace_symbols"), picker_opts)
    vim.keymap.set("n", "<leader>ss", snacks_picker("lsp_symbols"), picker_opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
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

vim.lsp.config("*", {
  capabilities = blink.get_lsp_capabilities(),
})

vim.lsp.config("vtsls", {})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.config("oxlint", {
  filetypes = js_filetypes,
  root_markers = js_root_markers,
  workspace_required = false,
})

vim.lsp.config("oxfmt", {
  cmd = { "oxfmt", "--lsp" },
  filetypes = js_filetypes,
  root_markers = js_root_markers,
})

for _, server in ipairs({
  "vtsls",
  "gopls",
  "rust_analyzer",
  "oxlint",
  "oxfmt",
}) do
  vim.lsp.enable(server)
end
