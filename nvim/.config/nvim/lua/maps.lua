local keymap = vim.keymap
local api = vim.api

local function term_float()
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
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  return buf, win
end

local function term_fullscreen()
  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  })

  vim.bo[buf].bufhidden = "wipe"
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  return buf, win
end

local function term_tab()
  vim.cmd("tabnew")

  local buf = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()
  local tab = api.nvim_get_current_tabpage()

  vim.bo[buf].bufhidden = "wipe"
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  return buf, win, tab
end

local function reload_changed_buffers()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      api.nvim_buf_call(buf, function()
        vim.cmd("silent! checktime")
      end)
    end
  end
end

local function restore_ui()
  local mouse = vim.o.mouse
  vim.cmd("redraw!")
  vim.o.mouse = ""
  vim.o.mouse = mouse
end

local function open_term_command(cmd, opts)
  opts = opts or {}

  vim.cmd("silent! wall")

  local previous_laststatus = vim.o.laststatus
  local previous_showtabline = vim.o.showtabline
  local buf, win, tab
  if opts.layout == "tab" then
    buf, win, tab = term_tab()
  elseif opts.layout == "full" then
    buf, win = term_fullscreen()
  else
    buf, win = term_float()
  end

  if opts.hide_ui then
    vim.o.laststatus = 0
    vim.o.showtabline = 0
  end

  if opts.filetype then
    vim.bo[buf].filetype = opts.filetype
  end

  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.schedule(function()
        if opts.hide_ui then
          vim.o.laststatus = previous_laststatus
          vim.o.showtabline = previous_showtabline
        end
        if tab and api.nvim_tabpage_is_valid(tab) then
          vim.cmd("tabclose")
        elseif api.nvim_win_is_valid(win) then
          api.nvim_win_close(win, true)
        end
        if opts.reload_buffers ~= false then
          reload_changed_buffers()
        end
        restore_ui()
        if opts.on_exit then
          opts.on_exit()
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

local function open_lazygit()
  open_term_command({ "lazygit" }, { filetype = "lazygit" })
end

local function open_vigil()
  local chooser_file = vim.fn.tempname()

  open_term_command({ "vigil", "--chooser-file", chooser_file }, {
    filetype = "vigil",
    layout = "full",
    hide_ui = true,
    reload_buffers = false,
    on_exit = function()
      if vim.fn.filereadable(chooser_file) ~= 1 then
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

  open_term_command({ "vigil", "blame", string.format("%s:%d", file, line) }, {
    filetype = "vigil",
    reload_buffers = false,
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

keymap.set({ 'n', 'i' }, '<M-g>', open_lazygit, { desc = 'Open lazygit' })
keymap.set({ 'n', 'i' }, '<M-r>', open_vigil, { desc = 'Open vigil chooser' })
keymap.set({ 'n', 'i' }, '<M-b>', open_vigil_blame, { desc = 'Open vigil blame' })

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
