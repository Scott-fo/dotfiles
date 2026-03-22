return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
    },
    keys = {
      {
        "<C-/>",
        function()
          require("snacks").terminal()
        end,
        desc = "Terminal",
      },
      {
        "<C-_>",
        function()
          require("snacks").terminal()
        end,
        desc = "Terminal",
      },
      {
        "<M-g>",
        function()
          require("snacks").lazygit()
        end,
        mode = { "n", "i" },
        desc = "Lazygit",
      },
      {
        "<leader>e",
        function()
          require("snacks").explorer()
        end,
        desc = "Explorer",
      },
    },
  },
}
