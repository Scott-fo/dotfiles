local present, lualine = pcall(require, "lualine")
if not present then
  return
end

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

local function mode_label()
  return mode_names[vim.api.nvim_get_mode().mode] or "NOR"
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

lualine.setup({
  options = {
    theme = "catppuccin",
    globalstatus = true,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {
      winbar = { "snacks_terminal", "vigil" },
    },
  },
  sections = {
    lualine_a = { mode_label },
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [RO]",
          unnamed = "[No Name]",
          newfile = " [New]",
        },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "warn", "error" },
        symbols = { error = "● ", warn = "● " },
      },
      selection_count,
    },
    lualine_y = {},
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [RO]",
          unnamed = "[No Name]",
          newfile = " [New]",
        },
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
})
