local keymap = vim.keymap
local api = vim.api

local function reload_changed_buffers()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      api.nvim_buf_call(buf, function()
        vim.cmd("silent! checktime")
      end)
    end
  end
end

local function open_lazygit()
  vim.cmd("silent! wall")

  local buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "lazygit"
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  vim.fn.termopen("lazygit", {
    on_exit = function()
      vim.schedule(function()
        if api.nvim_win_is_valid(win) then
          api.nvim_win_close(win, true)
        end
        reload_changed_buffers()
      end)
    end,
  })

  vim.cmd("startinsert")
end

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

keymap.set({ 'n', 'i' }, '<M-g>', open_lazygit, { desc = 'Open lazygit' })

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
