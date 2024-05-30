local status, prettier = pcall(require, 'prettier')
if (not status) then return end

prettier.setup {
  bin = 'prettierd',
  filetypes = {
    'vue',
    'html',
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'scss',
    'less',
    'php'
  }
}
