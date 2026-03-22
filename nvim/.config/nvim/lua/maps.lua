local keymap = vim.keymap
local api = vim.api

local function open_snacks_terminal(cmd, opts)
  opts = opts or {}
  local snacks = require("snacks")
  local previous_showtabline = vim.o.showtabline
  vim.cmd("silent! wall")

  if opts.hide_ui then
    vim.o.showtabline = 0
  end

  local terminal = snacks.terminal(cmd, {
    interactive = true,
    auto_close = true,
    cwd = opts.cwd,
    env = opts.env,
    win = vim.tbl_deep_extend("force", {
      position = "float",
      border = "rounded",
      width = 0.9,
      height = 0.9,
      bo = {
        filetype = opts.filetype or "snacks_terminal",
      },
      wo = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
      },
    }, opts.win or {}),
  })

  terminal:on("TermClose", function()
    vim.schedule(function()
      if opts.hide_ui then
        vim.o.showtabline = previous_showtabline
      end
      if opts.on_exit then
        opts.on_exit()
      end
    end)
  end, { buf = true })

  return terminal
end

local function open_vigil()
  local chooser_file = vim.fn.tempname()

  open_snacks_terminal({ "vigil", "--chooser-file", chooser_file }, {
    filetype = "vigil",
    hide_ui = true,
    win = {
      border = "none",
      width = 0,
      height = 0,
      row = 0,
      col = 0,
      backdrop = false,
    },
    on_exit = function()
      local readable = vim.fn.filereadable(chooser_file) == 1
      if not readable then
        vim.fn.delete(chooser_file)
        return
      end

      local lines = vim.fn.readfile(chooser_file)
      vim.fn.delete(chooser_file)
      local chosen = vim.trim(table.concat(lines, "\n"))
      if chosen == "" then
        return
      end

      vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(chosen, ":p")))
    end,
  })
end

local function open_vigil_blame()
  local file = api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file name", vim.log.levels.WARN)
    return
  end

  local line = api.nvim_win_get_cursor(0)[1]

  open_snacks_terminal({ "vigil", "blame", string.format("%s:%d", file, line) }, {
    filetype = "vigil",
    hide_ui = true,
    win = {
      border = "none",
      width = 0,
      height = 0,
      row = 0,
      col = 0,
      backdrop = false,
    },
  })
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

keymap.set('n', '<leader>c', 'gcc', { remap = true, desc = 'Toggle comment line' })
keymap.set('x', '<leader>c', 'gc', { remap = true, desc = 'Toggle comment selection' })

keymap.set({ 'n', 'i' }, '<M-r>', open_vigil, { desc = 'Open vigil chooser' })
keymap.set({ 'n', 'i' }, '<M-b>', open_vigil_blame, { desc = 'Open vigil blame' })

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
