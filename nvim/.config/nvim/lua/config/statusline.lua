local M = {}

local mode_names = {
  n = "NOR",
  no = "NOR",
  v = "VIS",
  V = "V-LN",
  ["\22"] = "V-BL",
  s = "SEL",
  S = "S-LN",
  ["\19"] = "S-BL",
  i = "INS",
  ic = "INS",
  R = "REP",
  Rv = "V-RP",
  c = "CMD",
  cv = "EX",
  ce = "EX",
  r = "PRO",
  rm = "MORE",
  ["r?"] = "CNF",
  ["!"] = "SH",
  t = "TERM",
}

local function current_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":~:.")
end

local function file_flags()
  local flags = {}

  if vim.bo.modified then
    table.insert(flags, "+")
  end

  if vim.bo.readonly or not vim.bo.modifiable then
    table.insert(flags, "RO")
  end

  if #flags == 0 then
    return ""
  end

  return " [" .. table.concat(flags, " ") .. "]"
end

local function diagnostic_counts()
  local bufnr = vim.api.nvim_get_current_buf()
  local counts = {
    errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
    warns = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
  }
  local parts = {}

  if counts.warns > 0 then
    table.insert(parts, "%#DiagnosticWarn#● " .. counts.warns .. "%*")
  end

  if counts.errors > 0 then
    table.insert(parts, "%#DiagnosticError#● " .. counts.errors .. "%*")
  end

  return table.concat(parts, " ")
end

local function selection_count()
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return ""
  end

  local start = vim.fn.getpos("v")
  local current = vim.fn.getpos(".")
  local count

  if mode == "V" then
    count = math.abs(current[2] - start[2]) + 1
  else
    count = math.abs(current[3] - start[3]) + 1
  end

  return tostring(count) .. " sel"
end

function M.statusline()
  local mode = mode_names[vim.api.nvim_get_mode().mode] or "NOR"
  local diagnostics = diagnostic_counts()
  local selection = selection_count()
  local parts = {
    " ",
    mode,
    "  ",
    current_path(),
    file_flags(),
    "%=",
  }

  if diagnostics ~= "" then
    table.insert(parts, diagnostics)
    table.insert(parts, "  ")
  end

  if selection ~= "" then
    table.insert(parts, selection)
    table.insert(parts, "  ")
  end

  table.insert(parts, "%l:%c ")

  return table.concat(parts)
end

_G.dotfiles_statusline = M

vim.o.winbar = ""
vim.o.statusline = "%!v:lua.dotfiles_statusline.statusline()"

return M
