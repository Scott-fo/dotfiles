local keymap = vim.keymap

-- Don't yank on x
keymap.set('n', 'x', '"_x')
keymap.set('n', 'd', '"_d')
keymap.set('n', 'D', '"_D')

-- Increment/Decrement numbers
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- New Tab
keymap.set('n', 'te', ':tabedit<Return>')

-- Horizontal Split
keymap.set('n', 'qs', ':split<Return><C-w>w')

-- Vertical Split
keymap.set('n', 'qv', ':vsplit<Return><C-w>w')

-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'qh', '<C-w>h')
keymap.set('', 'qk', '<C-w>k')
keymap.set('', 'qj', '<C-w>j')
keymap.set('', 'ql', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
vim.keymap.set('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
